{ lib, config, pkgs, ... }:
{
  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        "workgroup" = "Workgroup";
        "server string" = "Biriukov Home Server";
        "server role" = "standalone server";
        "min protocol" = "SMB2";
        "log file" = "/var/log/smb.%m";
        "max log size" = "50";
        "passdb backend" = "tdbsam";
        "obey pam restrictions" = "yes";
        "unix password sync" = "yes";
        "passwd program" = "/usr/bin/passwd %u";
        "passwd chat" = "*Enter\\snew\\s*\\spassword:* %n\\n *Retype\\snew\\s*\\spassword:* %n\\n *password\\supdated\\ssuccessfully* .";
        "pam password change" = "yes";
        "map to guest" = "bad user";
        "security" = "user";
        "usershare allow guests" = "yes";
        "ea support" = "yes";
        "vfs objects" = "fruit streams_xattr";
        "fruit:metadata" = "stream";
        "fruit:model" = "MacSamba";
        "fruit:veto_appledouble" = "no";
        "fruit:posix_rename" = "yes";
        "fruit:zero_file_id" = "yes";
        "fruit:wipe_intentionally_left_blank_rfork" = "yes";
        "fruit:delete_empty_adfiles" = "yes";
        "veto files" = "/._*/.DS_Store/";
        "delete veto files" = "yes";
        "disable spoolss" = "Yes";
        "show add printer wizard" = "No";
      };
      "zurg" = {
        "comment" = "Media files";
        "browseable" = "yes";
        "writable" = "no";
        "path" = "/media/zurg";
        "guest ok" = "yes";
      };
      "share" = {
        "comment" = "Share";
        "browseable" = "yes";
        "writable" = "yes";
        "path" = "/media/ssd/share";
        "guest ok" = "no";
      };
    };
  }; 
  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };
}
