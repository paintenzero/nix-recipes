{ config, lib, pkgs, pkgs-unstable, inputs, outputs, modulesPath, ... }:
let
  systemSettings = {
    system = "x86_64-linux";
    hostname = "sbnix";
    timezone = "Asia/Nicosia";
    locale = "en_US.UTF-8";
  };
in {

  imports = [ ./default.nix ];

  ### Hardware
  boot.initrd.availableKernelModules =
    [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/c51bcd68-dc1f-434c-b827-099da6bcad01";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/A263-0D08";
    fsType = "vfat";
    options = [ "fmask=0022" "dmask=0022" ];
  };

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault systemSettings.system;
  hardware.cpu.amd.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;

  #### Nvidia
  hardware = {
    graphics = {
      enable = true;
      #      extraPackages = with pkgs-unstable; [ nvidia-vaapi-driver ];
    };
    enableRedistributableFirmware = true;
    nvidia = {
      modesetting.enable = true;
      open = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.beta;
      forceFullCompositionPipeline = false;
    };
  };

  ### Software
  boot.loader = {
    systemd-boot.enable = true;
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
  };
  networking = {
    hostName = systemSettings.hostname;
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;
    firewall.enable = false;
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  };
  time.timeZone = systemSettings.timezone;
  i18n = {
    defaultLocale = systemSettings.locale;
    extraLocaleSettings = {
      LC_ADDRESS = systemSettings.locale;
      LC_IDENTIFICATION = systemSettings.locale;
      LC_MEASUREMENT = systemSettings.locale;
      LC_MONETARY = systemSettings.locale;
      LC_NAME = systemSettings.locale;
      LC_NUMERIC = systemSettings.locale;
      LC_PAPER = systemSettings.locale;
      LC_TELEPHONE = systemSettings.locale;
      LC_TIME = systemSettings.locale;
    };
  };
  console = { keyMap = "us"; };

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Disable Sleep
  systemd.targets = {
    sleep.enable = false;
    suspend.enable = false;
    hibernate.enable = false;
    hybrid-sleep.enable = false;
  };

  services.openssh.enable = true;
  security.sudo.wheelNeedsPassword = false;

  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    home-manager
    git
    htop
    pciutils
    lm_sensors
    cachix
  ];

  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  programs.firefox.enable = true;

  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
    xkb.layout = "us,ru";
    xkb.options = "grp:alt_shift_toggle";
  };
  services.desktopManager.plasma6.enable = true;
  services.displayManager = {
    autoLogin.enable = true;
    autoLogin.user = "sergey";
  };
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    settings.General.DisplayServer = "wayland";
  };

  gaming.enable = true;
  ollama.enable = true;
  cuda.enable = true;
  services.tailscale.enable = true;
}
