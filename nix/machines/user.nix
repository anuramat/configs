{
  hostname,
  hostnames,
  lib,
}:
let
  inherit (builtins)
    filter
    concatLists
    readDir
    attrNames
    pathExists
    readFile
    ;
  inherit (lib.strings) hasSuffix;

  getMachine =
    hostname:
    let
      cacheFilename = "cache.pem.pub";
      cachePath = path + "/${cacheFilename}";
      path = ./${hostname}/keys;
      meta = import ./${hostname}/meta.nix;
    in
    {
      inherit hostname;
      inherit (meta) builder platform;
      cacheKey = if pathExists cachePath then readFile cachePath else null;
      clientKeyFiles = (
        readDir path
        |> attrNames
        |> filter (x: hasSuffix ".pub" x && x != cacheFilename)
        |> map (x: path + /${x})
      );
      hostKeysFile = path + "/host_keys";
    };

  machines = hostnames |> map getMachine;
  others = filter (x: x.hostname != hostname) machines;
  builders = filter (x: x.builder) others;
  this = (getMachine hostname);
in
# TODO split the file?
{
  inherit builders this;
  username = "anuramat";
  fullname = "Arsen Nuramatov";
  timezone = "Europe/Berlin";
  defaultLocale = "en_US.UTF-8";
  # TODO separate keys for builder -- only other machines
  keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKl0YHcx+ju+3rsPerkAXoo2zI4FXRHaxzfq8mNHCiSD anuramat-iphone16"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINBre248H/l0+aS5MJ+nr99m10g44y+UsaKTruszS6+D anuramat-ipad"
  ];
  clientKeyFiles = others |> map (x: x.clientKeyFiles) |> concatLists;
  substituters = builders |> map (x: "ssh-ng://${x.hostname}");
  trusted-public-keys = builders |> map (x: x.cacheKey) |> filter (x: x != null);
  builderUsername = "builder";
  hostKeysFiles = others |> map (x: x.hostKeysFile);
}
