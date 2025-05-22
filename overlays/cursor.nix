final: prev: {
  cursor = prev.cursor.overrideAttrs (oldAttrs: {
    version = "0.50.5";
    sources = {
      x86_64-linux = prev.fetchurl {
        url = "https://downloads.cursor.com/production/96e5b01ca25f8fbd4c4c10bc69b15f6228c80771/linux/x64/Cursor-0.50.5-x86_64.AppImage";
        hash = prev.lib.fakeSha256;
      };
    };
  });
}