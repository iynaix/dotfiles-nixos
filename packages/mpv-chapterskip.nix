{
  stdenvNoCC,
  fetchFromGitHub,
  lib,
}:
stdenvNoCC.mkDerivation {
  name = "mpv-chapterskip";
  version = "unstable-2002-09-09";

  src = fetchFromGitHub {
    owner = "po5";
    repo = "chapterskip";
    rev = "b26825316e3329882206ae78dc903ebc4613f039";
    hash = "sha256-OTrLQE3rYvPQamEX23D6HttNjx3vafWdTMxTiWpDy90=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/mpv/scripts
    cp chapterskip.lua $out/share/mpv/scripts/chapterskip.lua

    runHook postInstall
  '';

  passthru.scriptName = "chapterskip.lua";

  meta = {
    description = "Automatiacally skip chapters based on title";
    homepage = "https://github.com/po5/chapterskip";
    maintainers = with lib.maintainers; [iynaix];
  };
}