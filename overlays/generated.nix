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
    version = "ddb0d5dbc83960d0c834d2a4dcb7f541474cb854";
    src = fetchFromGitHub {
      owner = "LGFae";
      repo = "swww";
      rev = "ddb0d5dbc83960d0c834d2a4dcb7f541474cb854";
      fetchSubmodules = false;
      sha256 = "sha256-Yg7c0XUgn82aNftvzSXTKMtZT1gdskun710aO5Dnd9M=";
    };
    date = "2024-09-19";
  };
  wallust = {
    pname = "wallust";
    version = "0d452c203c01e89ee80d32f605329118ffa0db44";
    src = fetchgit {
      url = "https://codeberg.org/explosion-mental/wallust";
      rev = "0d452c203c01e89ee80d32f605329118ffa0db44";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-Tad+zyhmTr734GEW0A4SNrfWzqcL0gLFsM6MoMrV17k=";
    };
    date = "2024-10-13";
  };
  yazi-plugins = {
    pname = "yazi-plugins";
    version = "7715b94be546768e31b1c0ab4b32b84656b03fe5";
    src = fetchFromGitHub {
      owner = "yazi-rs";
      repo = "plugins";
      rev = "7715b94be546768e31b1c0ab4b32b84656b03fe5";
      fetchSubmodules = false;
      sha256 = "sha256-YtOoe0QfR8MZLSUSuAdAksqvOAb5/oTcI9UpYvRKAIk=";
    };
    date = "2024-10-14";
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
    version = "2024.10.07";
    src = fetchFromGitHub {
      owner = "yt-dlp";
      repo = "yt-dlp";
      rev = "2024.10.07";
      fetchSubmodules = false;
      sha256 = "sha256-+ktz3f+Wm4OkzJvGuWCavsfr0TB/solGwhE6XliVB4g=";
    };
  };
}
