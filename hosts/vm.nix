{ config, lib, pkgs, pkgs-unstable, unstable, inputs, outputs, modulesPath
, impermanence, ... }:
let
  systemSettings = {
    system = "x86_64-linux";
    hostname = "vmnix";
    timezone = "Asia/Nicosia";
    locale = "en_US.UTF-8";
  };
in {

  imports = [ ./default.nix ];

  ### Hardware
  boot.initrd.availableKernelModules = [ ];
  boot.initrd.kernelModules = [ ];
  boot.kernelPackages = unstable.linuxPackages;
  boot.kernelModules = [ ];
  boot.kernelParams = [ "video=hyperv_fb:1024x768" ];
  boot.extraModulePackages = [ ];
  #  boot.blacklistedKernelModules = [ "hyperv_fb" ];
  boot.kernel.sysctl."vm.overcommit_memory" = "1";

  boot.initrd.postResumeCommands = lib.mkAfter ''
    mkdir /btrfs_tmp
    mount -o subvol=/ /dev/disk/by-label/NIX /btrfs_tmp

    if [[ -e /btrfs_tmp/root ]]; then
        mkdir -p /btrfs_tmp/old_roots
        timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
        mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
    fi

    delete_subvolume_recursively() {
        IFS=$'\n'
        for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
            delete_subvolume_recursively "/btrfs_tmp/$i"
        done
        btrfs subvolume delete "$1"
    }

    for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +3); do
        delete_subvolume_recursively "$i"
    done

    btrfs subvolume create /btrfs_tmp/root
    umount /btrfs_tmp
  '';

  virtualisation.hypervGuest = { enable = true; };

  fileSystems."/" = {
    device = "/dev/disk/by-label/NIX";
    fsType = "btrfs";
    options = [ "compress=zstd" "subvol=root" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/BOOT";
    fsType = "vfat";
    options = [ "fmask=0022" "dmask=0022" ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-label/NIX";
    fsType = "btrfs";
    options = [ "compress=zstd" "subvol=nix" ];
  };

  fileSystems."/persist" = {
    device = "/dev/disk/by-label/NIX";
    fsType = "btrfs";
    options = [ "compress=zstd" "subvol=persist" ];
    neededForBoot = true;
  };

  #  fileSystems."/vm-share" = {
  #    fsType = "cifs";
  #    device = "//192.168.2.9/Share";
  #    options = [ "username=shares-guest" "password=ReplaceWithSomeLongRandomlyGeneratedPassword" ];
  #  };

  nixpkgs.hostPlatform = lib.mkDefault systemSettings.system;
  hardware.cpu.amd.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;

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
  security.sudo = {
    wheelNeedsPassword = false;
    extraConfig = ''
      Defaults lecture = never
    '';
  };

  environment.systemPackages = with unstable; [
    vim
    wget
    curl
    home-manager
    git
    htop
    btop
    cachix
    ripgrep
    devenv
    samba
  ];

  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    package = unstable.direnv;
  };

  programs.firefox.enable = true;
  rdp.enable = true;
  build-essentials.enable = true;

  services.xserver = {
    enable = true;
    xkb.layout = "us,ru";
    xkb.options = "grp:alt_shift_toggle";
  };
  services.desktopManager.plasma6.enable = true;
  services.displayManager = {
    autoLogin.enable = false;
    autoLogin.user = "sergey";
  };
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    settings.General.DisplayServer = "wayland";
  };

  fonts.enableDefaultPackages = true;
  fonts.enableGhostscriptFonts = true;
  fonts.packages = with pkgs; [
    nerdfonts
    corefonts
    vistafonts
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
  ];
  fonts.fontconfig.enable = true;

  environment.persistence."/persist/system" = {
    hideMounts = true;
    directories = [ "/var/lib/nixos" "/etc/nixos" "/etc/ssh" ];
    files = [ "/etc/machine-id" ];
  };
}
