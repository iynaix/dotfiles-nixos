# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  swww = {
    pname = "swww";
    version = "d60139dffe3fb7ee26814fed292fdcca2309df31";
    src = fetchFromGitHub {
      owner = "LGFae";
      repo = "swww";
      rev = "d60139dffe3fb7ee26814fed292fdcca2309df31";
      fetchSubmodules = false;
      sha256 = "sha256-n7YdUmIZGu7W7cX6OvVW+wbkKjFvont4hEAhZXYDQd8=";
    };
    date = "2024-01-15";
  };
  waybar = {
    pname = "waybar";
    version = "07eabc5328dc5056f667a93f58549314d10f007b";
    src = fetchFromGitHub {
      owner = "Alexays";
      repo = "Waybar";
      rev = "07eabc5328dc5056f667a93f58549314d10f007b";
      fetchSubmodules = false;
      sha256 = "sha256-Tbhj9nAP3PoECFWVVk3bciM+x1Vw6MVo779OqSFfZ/Y=";
    };
    date = "2024-01-14";
  };
}
