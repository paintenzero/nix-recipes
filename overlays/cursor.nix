final: prev: {
  code-cursor = prev.code-cursor.overrideAttrs (oldAttrs: rec {
    pname = "cursor";
    version = "0.50.5";

    source = prev.fetchurl {
      url = "https://downloads.cursor.com/production/96e5b01ca25f8fbd4c4c10bc69b15f6228c80771/linux/x64/Cursor-0.50.5-x86_64.AppImage";
      sha256 = "sha256-DUWIgQYD3Wj6hF7NBb00OGRynKmXcFldWFUA6W8CZeM=";
    };

    # Linux -- build from AppImage
    appimageContents = prev.appimageTools.extractType2 {
      inherit version pname;
      src = source;
    };

    wrappedAppimage = prev.appimageTools.wrapType2 {
      inherit version pname;
      src = source;
    };
  });
}