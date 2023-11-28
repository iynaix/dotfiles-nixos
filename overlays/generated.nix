# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  path-of-building = {
    pname = "path-of-building";
    version = "v2.34.1";
    src = fetchFromGitHub {
      owner = "PathOfBuildingCommunity";
      repo = "PathOfBuilding";
      rev = "v2.34.1";
      fetchSubmodules = false;
      sha256 = "sha256-i6OCW5Vc9/LfNuiaEeelmXiqP7+WdIklRNRcgWb7L1w=";
    };
  };
  swww = {
    pname = "swww";
    version = "5db225cb88b785a1d1105b14891a91e5a850c15f";
    src = fetchFromGitHub {
      owner = "Horus645";
      repo = "swww";
      rev = "5db225cb88b785a1d1105b14891a91e5a850c15f";
      fetchSubmodules = false;
      sha256 = "sha256-arNxr+5kaORxDvWnGq1fBHRuSLG9uZZ1f5PRX5qP1RA=";
    };
    date = "2023-11-26";
  };
  transmission-web-soft-theme = {
    pname = "transmission-web-soft-theme";
    version = "a957b41b0303e6b74e67191311e0d2af9b60a965";
    src = fetchFromGitHub {
      owner = "diesys";
      repo = "transmission-web-soft-theme";
      rev = "a957b41b0303e6b74e67191311e0d2af9b60a965";
      fetchSubmodules = false;
      sha256 = "sha256-KngN44lnhv0sga0otYC9F5xoqLDDIVxobXRlhhhSmHo=";
    };
    date = "2021-01-28";
  };
  waybar = {
    pname = "waybar";
    version = "58db0baaf48937554de9ce5f962e2103a33585e9";
    src = fetchFromGitHub {
      owner = "Alexays";
      repo = "Waybar";
      rev = "58db0baaf48937554de9ce5f962e2103a33585e9";
      fetchSubmodules = false;
      sha256 = "sha256-Wqd9HuzerxP6s7bjYPQBR0NPS083lB8ApzKy6SrOtWc=";
    };
    date = "2023-11-28";
  };
  wezterm = {
    pname = "wezterm";
    version = "90ca1117bc68e3644b1763460e17cf4b6ffbf1c3";
    src = fetchFromGitHub {
      owner = "wez";
      repo = "wezterm";
      rev = "90ca1117bc68e3644b1763460e17cf4b6ffbf1c3";
      fetchSubmodules = true;
      sha256 = "sha256-h0L+D8OOilaVPizLqVj2wYzPfrcpqVNwni79I0ebsms=";
    };
    date = "2023-11-28";
  };
}
