_: {
            system.stateVersion = "24.05";

            networking.hostName = "anuramat-t480";

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 32 * 1024;
    }
  ];

  boot = {
    # boot splashscreen
    plymouth = {
      enable = true;
      theme = "breeze"; # package is overridden to use a nixos logo
    };
    kernelModules = ["v4l2loopback"]; # virtual webcam
  };
}
