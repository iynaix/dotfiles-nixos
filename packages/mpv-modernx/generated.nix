# This file was generated by nvfetcher, please do not modify it manually.
{ fetchFromGitHub, dockerTools }:
{
  mpv-modernx = {
    pname = "mpv-modernx";
    version = "d053ea602d797bdd85d8b2275d7f606be067dc21";
    src = fetchFromGitHub {
      owner = "cyl0";
      repo = "ModernX";
      rev = "d053ea602d797bdd85d8b2275d7f606be067dc21";
      fetchSubmodules = false;
      sha256 = "sha256-Gpofl529VbmdN7eOThDAsNfNXNkUDDF82Rd+csXGOQg=";
    };
    date = "2023-01-12";
  };
}
