{ config, lib, modulesPath, pkgs, impermanence, ... }@inputs:
let
  systemSettings = {
    system = inputs.system;
    hostname = "sbsrv";
    timezone = "Asia/Krasnoyarsk";
    locale = "en_US.UTF-8";
    secretsFile = ../secrets/services.yaml;
    keyFile = "/persist/keys/age_key.txt";
  };
in {
  imports = [
    "${modulesPath}/installer/scan/not-detected.nix"
    "${modulesPath}/profiles/qemu-guest.nix"
    ../roles/server
    ../roles/wireguard
  ];
  nixpkgs.hostPlatform = lib.mkDefault systemSettings.system;

  ### MOUNTS
  fileSystems."/" =
    { device = "/dev/disk/by-label/NIX";
      fsType = "btrfs";
      options = [ "subvol=root" "compress=zstd" "noatime" ];
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-label/NIX";
      fsType = "btrfs";
      options = [ "subvol=nix" "compress=zstd" "noatime" ];
    };

  fileSystems."/persist" =
    { device = "/dev/disk/by-label/NIX";
      fsType = "btrfs";
      options = [ "subvol=persist" "compress=zstd" "noatime" ];
      neededForBoot = true;
    };

  fileSystems."/var/log" =
    { device = "/dev/disk/by-label/NIX";
      fsType = "btrfs";
      options = [ "subvol=log" "compress=zstd" "noatime" ];
      neededForBoot = true;
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-label/BOOT";
      fsType = "ext4";
    };

  swapDevices = [ ];

  ### BOOTLOADER
  mbr.enable = true;

  boot.initrd.availableKernelModules = [ "uhci_hcd" "ehci_pci" "ahci" "virtio_pci" "virtio_scsi" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];

  ### KERNEL
#  boot.kernelPackages = pkgs.linuxKernel;
#  boot.kernelModules = [ ];
#  boot.extraModulePackages = [ ];
#  boot.kernelParams = [ ];
  boot.kernel.sysctl."vm.overcommit_memory" = "1";

  ### NETWORK
  networking = {
    hostName = systemSettings.hostname;
    networkmanager.enable = true;
    firewall.enable = true;
    interfaces.enp6s18.ipv4.addresses = [{
      address = "192.168.1.28";
      prefixLength = 24;
    }];
    defaultGateway = "192.168.1.1";
    nameservers = [ "77.88.8.8" "77.88.8.1" ];
  };

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
      "wireguard/private" = { };
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
    directories = [ "/var/lib/nixos" "/etc/nixos" "/etc/ssh" ];
    files = [ "/etc/machine-id" ];
  };
  ephemeral.enable = true;
}
