{ pkgs, ... }:
let
  subs = [
    "https://cache.nixos.org"
    "https://cuda-maintainers.cachix.org"
    "https://devenv.cachix.org"
    "https://nix-community.cachix.org"
    "https://nixpkgs-python.cachix.org"
    "http://anuramat-ll7:5000"
    # "https://cache.iog.io"
  ];
in
{
  nix = {
    channel.enable = false;
    nixPath = [ ];
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = subs; # used by default
      trusted-substituters = subs; # merely allowed
      trusted-public-keys = [
        "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "anuramat-ll7:aFFmygZTV872vjBs+mugpBgkTObki/bi5xfJspLKeSc="
        # "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
      ];
    };
  };
  nixpkgs.config = {
    allowUnfree = true;
    # cudaSupport = true; # breaks nomacs, mathematica takes a lot of time to compile
    # cudnnSupoprt = true;
  };
  environment.systemPackages = [
    pkgs.nix-index
  ];
}
