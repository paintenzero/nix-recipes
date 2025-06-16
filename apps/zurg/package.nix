{
  lib,
  stdenv,
  fetchzip,
  autoPatchelfHook
}:

stdenv.mkDerivation rec {
  pname = "zurg";
  version = "0.9.3-final";

  src = fetchzip {
    url = "https://github.com/debridmediamanager/zurg-testing/releases/download/v0.9.3-final/zurg-v0.9.3-final-linux-arm64.zip";
    sha256 = "sha256-fBc9tVeS3dIiZGYzvYVFXVh978HKS/U0scISpxwQs5M=";
  };

  buildInputs = [ ];

  nativeBuildInputs = [ autoPatchelfHook ];

  dontConfigure = true;
  dontBuild = true;
  doInstallCheck = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 zurg $out/bin/zurg
    mkdir -p $out/etc/zurg

    runHook postInstall
  '';

  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/zurg version >/dev/null

    runHook postInstallCheck
  '';

  meta = with lib; {
    description = "A self-hosted Real-Debrid webdav server written from scratch.";
    homepage = "https://github.com/debridmediamanager/zurg-testing";
    changelog = "https://github.com/debridmediamanager/zurg-testing/wiki/History";
    license = licenses.mit;
    mainProgram = "zurg";
    maintainers = with maintainers; [
      paintenzero
    ];
  };
}

