{pkgs, ...}: let
  ytdl = pkgs.writeShellApplication {
    name = "ytdl";
    runtimeInputs = with pkgs; [yt-dlp];
    text = ''
      cd "$HOME/Downloads"

      # add and remove torrent lines
      if command -v "torrents-add" &> /dev/null; then
        torrents-add
      fi

      yt-dlp -a "$HOME/Desktop/yt.txt"

      cd - > /dev/null
    '';
  };
in {
  programs = {
    yt-dlp = {
      enable = true;
      settings = {
        add-metadata = true;
        format = "best[ext=mp4]";
        no-mtime = true;
        output = "%(title)s.%(ext)s";
        sponsorblock-mark = "all";
        windows-filenames = true;
      };
    };
  };

  home = {
    packages = [ytdl];

    shellAliases = {
      yt = "yt-dlp";
      ytaudio = "yt-dlp --audio-format mp3 --extract-audio";
      ytsub = "yt-dlp --write-auto-sub --sub-lang='en,eng' --convert-subs srt";
      ytplaylist = "yt-dlp --output '%(playlist_index)d - %(title)s.%(ext)s'";
    };
  };
}
