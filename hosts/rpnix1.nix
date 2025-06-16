{ config, lib, modulesPath, pkgs, impermanence, ... }@inputs:
let
  systemSettings = {
    system = inputs.system;
    hostname = "rpnix1";
    timezone = "Asia/Nicosia";
    locale = "en_US.UTF-8";
    secretsFile = ../secrets/secrets.yaml;
    keyFile = "/persist/keys/age_key.txt";
  };
in {
  imports = [
    "${modulesPath}/installer/scan/not-detected.nix"
    "${modulesPath}/profiles/qemu-guest.nix"
    ../roles/server
    ../roles/mediaserver
    ../roles/fileserver
    ../roles/simreader
    ../roles/xray
  ];
  nixpkgs.hostPlatform = lib.mkDefault systemSettings.system;

  ### MOUNTS
  fileSystems = {
    "/" = { 
      device = "/dev/disk/by-label/NIX";
      fsType = "btrfs";
      options = [ "subvol=root" "compress=zstd" "noatime" ];
    };

    "/nix" = {
      device = "/dev/disk/by-label/NIX";
      fsType = "btrfs";
      options = [ "subvol=nix" "compress=zstd" "noatime" ];
    };

    "/persist" = {
      device = "/dev/disk/by-label/NIX";
      fsType = "btrfs";
      options = [ "subvol=persist" "compress=zstd" "noatime" ];
      neededForBoot = true;
    };

    "/var/log" = {
      device = "none";
      fsType = "tmpfs";
      options = [ "size=100M" ];
      neededForBoot = true;
    };

    "/boot" = {
      device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
    };

    "/media/ssd" = {
      device = "/dev/disk/by-label/256G";
      fsType = "btrfs";
      options = [ "compress=zstd" "noatime" ];
    };
  };

  swapDevices = [ ];

  ### BOOTLOADER

  ### KERNEL
  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;
    initrd.availableKernelModules = [ "xhci_pci" "usbhid" "usb_storage" ];
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
  };

  ### NETWORK
  networking = {
    hostName = systemSettings.hostname;
    networkmanager.enable = true;
    firewall.enable = true;
    firewall.allowedTCPPorts = [ 1080 ];
  };

  environment.systemPackages = with pkgs; [ 
    git
    rclone
    helix
  ];

  ### LOCALIZATION
  time.timeZone = systemSettings.timezone;
  i18n.defaultLocale = systemSettings.locale;
  console = { keyMap = "us"; };

  ### SOFTWARE
  sops = {
    defaultSopsFile = systemSettings.secretsFile;
    defaultSopsFormat = "yaml";
    age.keyFile = systemSettings.keyFile;
    secrets = {
      "zurg_token" = {};
      "sim_reader/config" = {};
      "xray/config" = {};
    };
  };

  security.sudo = {
    wheelNeedsPassword = false;
    extraConfig = ''
      Defaults lecture = never
    '';
  };

  environment.persistence."/persist/system" = {
    enable = true;
    hideMounts = true;
    directories = [ "/var/lib/nixos" "/etc/nixos" "/etc/ssh" "/var/lib/samba" ];
    files = [ "/etc/machine-id" ];
  };
  ephemeral.enable = true;
}
