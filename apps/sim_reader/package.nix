{
  lib,
  stdenv,
  fetchzip,
  autoPatchelfHook,
  pkgs
}:

stdenv.mkDerivation rec {
  pname = "sim_reader";
  version = "2.0.4";

  src = ./.; 
  buildInputs = with pkgs; [
    udev
  ];

  nativeBuildInputs = [ autoPatchelfHook ];

  dontConfigure = true;
  dontBuild = true;
  doInstallCheck = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 sim_reader_arm64 $out/bin/sim_reader

    runHook postInstall
  '';

  installCheckPhase = ''
    runHook preInstallCheck

    runHook postInstallCheck
  '';

  meta = with lib; {
    description = "A Sistematics SIM Reader that work's with Sistematics SSC boards";
    homepage = "https://sistematics.ru";
    license = licenses.mit;
    mainProgram = "sim_reader";
    maintainers = with maintainers; [
      paintenzero
    ];
  };
}

