# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  path-of-building = {
    pname = "path-of-building";
    version = "v2.49.2";
    src = fetchFromGitHub {
      owner = "PathOfBuildingCommunity";
      repo = "PathOfBuilding";
      rev = "v2.49.2";
      fetchSubmodules = false;
      sha256 = "sha256-rxvReL2ofdaQdKmIg2lMDT0thN1IkeJMf1B7+HWlQaI=";
    };
  };
  swww = {
    pname = "swww";
    version = "0db3f4eb192f1c9bf914efcc1d2aba809da5d78a";
    src = fetchFromGitHub {
      owner = "LGFae";
      repo = "swww";
      rev = "0db3f4eb192f1c9bf914efcc1d2aba809da5d78a";
      fetchSubmodules = false;
      sha256 = "sha256-+8YUJsNzvgAeZYLfbHYfYlad/iS+6Eec/LWzL1ZIGfY=";
    };
    date = "2024-10-31";
  };
  wallust = {
    pname = "wallust";
    version = "7ff46aa6fcbbb872b33da72325a8c341107293ea";
    src = fetchgit {
      url = "https://codeberg.org/explosion-mental/wallust";
      rev = "7ff46aa6fcbbb872b33da72325a8c341107293ea";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-oqrNcyOQuAeWsEqni2kzTwVOrF44YGNAuqXyBEEKGzc=";
    };
    date = "2024-11-09";
  };
  yazi-plugins = {
    pname = "yazi-plugins";
    version = "ab7068ef7569a477899e2aebe5948e933909c38d";
    src = fetchFromGitHub {
      owner = "yazi-rs";
      repo = "plugins";
      rev = "ab7068ef7569a477899e2aebe5948e933909c38d";
      fetchSubmodules = false;
      sha256 = "sha256-0is0kiLEvTUasOGX882OnnrkvTUGVlfT4ohBmrWY8pc=";
    };
    date = "2024-11-20";
  };
  yazi-time-travel = {
    pname = "yazi-time-travel";
    version = "737c9bc79142b05616c2fa8f3a246615755dffd8";
    src = fetchFromGitHub {
      owner = "iynaix";
      repo = "time-travel.yazi";
      rev = "737c9bc79142b05616c2fa8f3a246615755dffd8";
      fetchSubmodules = false;
      sha256 = "sha256-cmGyT8pwMU3xmk5Or9zcsDlKz8wPiuRdwb/Yhjefo2U=";
    };
    date = "2024-11-12";
  };
  yt-dlp = {
    pname = "yt-dlp";
    version = "2024.11.18";
    src = fetchFromGitHub {
      owner = "yt-dlp";
      repo = "yt-dlp";
      rev = "2024.11.18";
      fetchSubmodules = false;
      sha256 = "sha256-TpQry/qUxqAvj4gQJecGSAlw850WxjK1KU43JpecPAU=";
    };
  };
}
