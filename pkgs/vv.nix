{pkgs ? import <nixpkgs> {}}:
with pkgs;
# based off derivation for lsix
# https://github.com/NixOS/nixpkgs/blob/master/pkgs/tools/graphics/lsix/default.nix
  stdenvNoCC.mkDerivation rec {
    pname = "vv";
    version = "1.9.2.1";

    src = fetchFromGitHub {
      owner = "hackerb9";
      repo = pname;
      rev = version;
      sha256 = "sha256-uN7MVasU2oFqKa94GcdB3R3Xt+9aVOKX6LWFPwfW80Y=";
    };
    nativeBuildInputs = [makeWrapper];

    installPhase = ''
      runHook preInstall
      install -Dm755 vv -t $out/bin
      runHook postInstall
    '';

    postFixup = ''
      wrapProgram $out/bin/vv \
        --prefix PATH : ${lib.makeBinPath [file imagemagick]}
    '';
  }
