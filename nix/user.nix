{ hostname, hostnames }:
let
  f = builtins.filter;
  machines = map (x: import ./machines/${x}/out.nix // { hostname = x; }) hostnames;
  builder = (import ./machines/${hostname}.nix).builder;
  others = f (x: x != hostname) machines;
  builders = f (x: x.builder) others;
in
{
  inherit hostname builders builder;
  username = "anuramat";
  fullname = "Arsen Nuramatov";
  timezone = "Europe/Berlin";
  defaultLocale = "en_US.UTF-8";
  keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKl0YHcx+ju+3rsPerkAXoo2zI4FXRHaxzfq8mNHCiSD anuramat-iphone16"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINBre248H/l0+aS5MJ+nr99m10g44y+UsaKTruszS6+D anuramat-ipad"
  ] ++ map (x: x.sshKey) others;
  # TODO disentangle ssh keys, move to builder_config.nix or something idk
  substituters = map (x: "http://${x.hostname}:5000") builders;
  trusted-public-keys = map (x: x.cacheKey) builders;
  builderUsername = "builder";
}
