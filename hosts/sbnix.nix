{ config, lib, modulesPath, pkgs, ... }:
let
  systemSettings = {
    system = "x86_64-linux";
    hostname = "sbnix";
    timezone = "Asia/Nicosia";
    locale = "en_US.UTF-8";
    secretsFile = ../secrets/secrets.yaml;
    keyFile = "/home/sergey/.config/sops/age/keys.txt";
  };
in {

  imports = [
    "${modulesPath}/installer/scan/not-detected.nix"
    ../arch/amd
    ../roles/workstation
    ../roles/developer
    ../roles/gaming
  ];
  nixpkgs.hostPlatform = lib.mkDefault systemSettings.system;

  ### MOUNTS
  fileSystems."/" = {
    device = "/dev/disk/by-label/NIX";
    fsType = "btrfs";
    options = [ "subvol=root" "compress=zstd" "noatime" ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-label/NIX";
    fsType = "btrfs";
    options = [ "subvol=home" "compress=zstd" "noatime" ];
    neededForBoot = true; # Because we keep sops secret file here
  };

  fileSystems."/var/lib/docker" = {
    device = "/dev/disk/by-label/NIX";
    fsType = "btrfs";
    options = [ "subvol=docker" "compress=zstd" "noatime" ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-label/NIX";
    fsType = "btrfs";
    options = [ "subvol=nix" "compress=zstd" "noatime" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/BOOT";
    fsType = "vfat";
    options = [ "fmask=0022" "dmask=0022" ];
  };

  fileSystems."/share" = {
    device = "//192.168.2.9/SHARE";
    fsType = "cifs";
    options = let
      automount_opts =
        "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
    in [
      "${automount_opts},credentials=${
        config.sops.secrets."samba/home_server/credentials".path
      },file_mode=0666,dir_mode=0777"
    ];
  };

  ### BOOTLOADER
  efi.enable = true;

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelPackages = pkgs.linuxPackages;
  boot.kernelModules = [ "kvm-amd" ];

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
    secrets = { "samba/home_server/credentials" = { }; };
  };

  ### SERVICES
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  security.sudo.wheelNeedsPassword = false;

  
  kde.enable = true;
  nvidia.enable = true;
  cuda.enable = true;
  appimage.enable = true;
  fonts.enable = true;
  ollama.enable = true;
  threedprint.enable = true;
  services.tailscale.enable = true;


  environment.systemPackages = with pkgs;
    [ git pciutils lm_sensors ripgrep htop btop devenv ];
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
  };

  # gaming.enable = true;

}
