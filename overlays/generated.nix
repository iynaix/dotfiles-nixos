# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  path-of-building = {
    pname = "path-of-building";
    version = "v2.42.0";
    src = fetchFromGitHub {
      owner = "PathOfBuildingCommunity";
      repo = "PathOfBuilding";
      rev = "v2.42.0";
      fetchSubmodules = false;
      sha256 = "sha256-OxAyB+tMszQktGvxlGL/kc+Wt0iInFYY0qHNjK6EnSg=";
    };
  };
  scope-tui = {
    pname = "scope-tui";
    version = "c2fe70a69cfc15c4de6ea3f2a51580ec57a5c9e1";
    src = fetchFromGitHub {
      owner = "alemidev";
      repo = "scope-tui";
      rev = "c2fe70a69cfc15c4de6ea3f2a51580ec57a5c9e1";
      fetchSubmodules = false;
      sha256 = "sha256-6UPIZ2UB5wb0IkigaOXdQ/0ux9vHUGC4w5WnrjEd1bg=";
    };
    date = "2024-05-06";
  };
  swww = {
    pname = "swww";
    version = "9a012646e66420ab8058b9f595cdfa0c14625755";
    src = fetchFromGitHub {
      owner = "LGFae";
      repo = "swww";
      rev = "9a012646e66420ab8058b9f595cdfa0c14625755";
      fetchSubmodules = false;
      sha256 = "sha256-b7rgfW6GSNwC0bolnlDDw8SV8ZgiChlbMeQ3Q1YfA4E=";
    };
  };
  wallust = {
    pname = "wallust";
    version = "432c491131a1569cad79277811660c7e25ce0908";
    src = fetchgit {
      url = "https://codeberg.org/explosion-mental/wallust.git";
      rev = "432c491131a1569cad79277811660c7e25ce0908";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-1x1REdL/pgzBWj/BnIbiRPJBiHxvwvhChRjjCWYEfHk=";
    };
    date = "2024-07-18";
  };
}
