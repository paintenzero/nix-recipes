{ lib, config, ... }: {
  options = {
    ephemeral.enable = lib.mkEnableOption "Make system impermanent";
  };

  config = lib.mkIf config.ephemeral.enable {

    # Impermanence: clean root volume before boot
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
  };
}
