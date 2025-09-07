{ config, lib, modulesPath, pkgs, packages, ... }:
let
  systemSettings = {
    system = "x86_64-linux";
    hostname = "worklaptop";
    timezone = "Asia/Nicosia";
    locale = "en_US.UTF-8";
    secretsFile = ../secrets/secrets.yaml;
    keyFile = "/home/sergey/.config/sops/age/keys.txt";
  };
in {

  imports = [
    "${modulesPath}/installer/scan/not-detected.nix"
    ../arch/intel
    ../roles/workstation
    ../roles/developer
    ../roles/xray
  ];
  nixpkgs.hostPlatform = lib.mkDefault systemSettings.system;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  hardware.sane = { enable = true; };

  ### MOUNTS
  fileSystems."/" = {
    device = "/dev/disk/by-label/ROOT";
    fsType = "btrfs";
    options = [ "subvol=root" "compress=zstd:6" "noatime" ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-label/ROOT";
    fsType = "btrfs";
    options = [ "subvol=home" "compress=zstd:6" "noatime" ];
    neededForBoot = true; # Because we keep sops secret file here
  };

  fileSystems."/var/log" = {
    device = "/dev/disk/by-label/ROOT";
    fsType = "btrfs";
    options = [ "subvol=varlog" "compress=zstd:9" "noatime" ];
  };

  fileSystems."/var/cache" = {
    device = "/dev/disk/by-label/ROOT";
    fsType = "btrfs";
    options = [ "subvol=varcache" "compress=zstd:9" "noatime" ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-label/ROOT";
    fsType = "btrfs";
    options = [ "subvol=nix" "compress=zstd:3" "noatime" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/BOOT";
    fsType = "vfat";
    options = [ "fmask=0022" "dmask=0022" ];
  };

  ### BOOTLOADER
  efi.enable = true;

  boot.initrd.availableKernelModules =
    [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelPackages = pkgs.linuxPackages;
  boot.kernelModules = [ "kvm-intel" ];

  ### NETWORK 
  networking = {
    hostName = systemSettings.hostname;
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;
    firewall.enable = false;
  };

  ### LOCALIZATION
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

  ### SOPS SECRETS
  sops = {
    defaultSopsFile = systemSettings.secretsFile;
    defaultSopsFormat = "yaml";
    age.keyFile = systemSettings.keyFile;
    secrets = {
      "samba/home_server/credentials" = { };
      "xray/config" = { };
    };
  };

  ### SERVICES
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  security.sudo.wheelNeedsPassword = false;

  kde.enable = true;
  appimage.enable = true;
  fonts.enable = true;
  services.tailscale.enable = true;

  environment.systemPackages = with pkgs; [
    git
    pciutils
    lm_sensors
    ripgrep
    htop
    btop
    devenv
    minicom
    mc
    squashfsTools
    wireshark
    sshfs
    iperf3
    tcpdump
    openfpgaloader
    dbeaver-bin
    arduino
  ];
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
  };
  programs.fuse = { userAllowOther = true; };
}
