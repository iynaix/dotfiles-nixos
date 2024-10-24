# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  path-of-building = {
    pname = "path-of-building";
    version = "v2.48.2";
    src = fetchFromGitHub {
      owner = "PathOfBuildingCommunity";
      repo = "PathOfBuilding";
      rev = "v2.48.2";
      fetchSubmodules = false;
      sha256 = "sha256-KMj+aS+xd96pt1NhqL3CBKj83ZfiX2npmJtwUFa00qU=";
    };
  };
  swww = {
    pname = "swww";
    version = "51428631811f6267f6aed4ff9d5d70e6213704e8";
    src = fetchFromGitHub {
      owner = "LGFae";
      repo = "swww";
      rev = "51428631811f6267f6aed4ff9d5d70e6213704e8";
      fetchSubmodules = false;
      sha256 = "sha256-9ipYYIw2QtmGaSlq3gMNP9gtpEezxfg/GomNrh58k9k=";
    };
    date = "2024-10-23";
  };
  wallust = {
    pname = "wallust";
    version = "571f0b6ba57e5bf9466b65ad8e7949ed198a2b02";
    src = fetchgit {
      url = "https://codeberg.org/explosion-mental/wallust";
      rev = "571f0b6ba57e5bf9466b65ad8e7949ed198a2b02";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-KsqpIqPFuxMXAQmiWL7dPk7RIew4Oj1PnmgDizUjJMU=";
    };
    date = "2024-10-21";
  };
  yazi-plugins = {
    pname = "yazi-plugins";
    version = "4fcd737db5f6cd4b5d6645659b16d891e1d93dd3";
    src = fetchFromGitHub {
      owner = "yazi-rs";
      repo = "plugins";
      rev = "4fcd737db5f6cd4b5d6645659b16d891e1d93dd3";
      fetchSubmodules = false;
      sha256 = "sha256-NNfPwiY1J+s/b2rajEdAubGsGKfFCA5ALz7MNX8wyGM=";
    };
    date = "2024-10-24";
  };
  yazi-zfs = {
    pname = "yazi-zfs";
    version = "dffe8db6858918ebb0d28088339b5a65d97cea05";
    src = fetchFromGitHub {
      owner = "iynaix";
      repo = "zfs.yazi";
      rev = "dffe8db6858918ebb0d28088339b5a65d97cea05";
      fetchSubmodules = false;
      sha256 = "sha256-7C18UnMD8SDYYzS2T3/DqXHPy9Q+0K8YteTwLQTwTSM=";
    };
    date = "2024-10-11";
  };
  yt-dlp = {
    pname = "yt-dlp";
    version = "2024.10.22";
    src = fetchFromGitHub {
      owner = "yt-dlp";
      repo = "yt-dlp";
      rev = "2024.10.22";
      fetchSubmodules = false;
      sha256 = "sha256-KlucN67zdxv1Fr/ftqirD5imES0PgScpZHSHA4lLgb8=";
    };
  };
}
