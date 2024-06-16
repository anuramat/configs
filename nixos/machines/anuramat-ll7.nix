{
  pkgs,
  config,
  ...
}: {
  environment.systemPackages = with pkgs; [
    lenovo-legion
  ];

  boot = {
    # initrd.kernelModules = ["nvidia"];
    extraModulePackages = [
      config.boot.kernelPackages.lenovo-legion-module
      # config.boot.kernelPackages.nvidia_x11
    ];
  };

  # from hidpi nixos-hardware module
  # console.earlySetup = true;

  services = {
    # ssd
    fstrim.enable = true;
    # doesn't support ll7g9, keep just in case
    hardware.openrgb.enable = true;
    # proprietary drivers
    xserver = {
      videoDrivers = ["nvidia"];
      dpi = 236;
    };
  };

  hardware = {
    nvidia = {
      modesetting.enable = true; # wiki says this is required
      # these two are experimental
      powerManagement = {
        enable = true; # saves entire vram to /tmp/ instead of the bare minimum
        finegrained = true; # turns off gpu when not in use
      };
      prime = {
        intelBusId = "PCI:00:02:0";
        nvidiaBusId = "PCI:01:00:0";
        # prime offloading
        offload = {
          enable = true;
          enableOffloadCmd = true; # `nvidia-offload`
        };
      };
      nvidiaSettings = true;
    };
    opengl = {
      extraPackages = with pkgs; [
        vaapiVdpau # no fucking idea what this does
      ];
      enable = true; # just in case, should be enabled by sway module
      driSupport = true; # on by default but whatever
      driSupport32Bit = true; # might be required for wine? might break on nouveau
    };
  };
}
