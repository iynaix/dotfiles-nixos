# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  path-of-building = {
    pname = "path-of-building";
    version = "v2.39.3";
    src = fetchFromGitHub {
      owner = "PathOfBuildingCommunity";
      repo = "PathOfBuilding";
      rev = "v2.39.3";
      fetchSubmodules = false;
      sha256 = "sha256-W4MmncDfeiuN7VeIeoPHEufTb9ncA3aA8F0JNhI9Z/o=";
    };
  };
  swww = {
    pname = "swww";
    version = "590aed24a938075a4d410de62b61c21a988323a3";
    src = fetchFromGitHub {
      owner = "LGFae";
      repo = "swww";
      rev = "590aed24a938075a4d410de62b61c21a988323a3";
      fetchSubmodules = false;
      sha256 = "sha256-BhjEh44gl+UW6PHqyQXgg1OECAL5AVbGFPzIoi3bktE=";
    };
    date = "2024-02-20";
  };
  waybar = {
    pname = "waybar";
    version = "793394c862b7ed1b2892d8815101a4567373092c";
    src = fetchFromGitHub {
      owner = "Alexays";
      repo = "Waybar";
      rev = "793394c862b7ed1b2892d8815101a4567373092c";
      fetchSubmodules = false;
      sha256 = "sha256-VryxmTIxBnLRmpVfYYMl0WyJFLz0OJFaVMFp6W0rSdc=";
    };
    date = "2024-02-22";
  };
}
