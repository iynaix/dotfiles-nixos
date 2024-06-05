{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  # include generated sources from nvfetcher
  sources = import ./generated.nix {
    inherit (pkgs)
      fetchFromGitHub
      fetchurl
      fetchgit
      dockerTools
      ;
  };
in
{
  nixpkgs.overlays = [
    (_: prev: {
      # include custom packages
      custom =
        (prev.custom or { })
        // {
          lib = pkgs.callPackage ./lib.nix { inherit (prev) pkgs; };
        }
        // (import ../packages {
          inherit (prev) pkgs;
          inherit inputs;
        });

      # nixos-small logo looks like ass
      fastfetch = prev.fastfetch.overrideAttrs (o: {
        patches = (o.patches or [ ]) ++ [ ./fastfetch-nixos-old-small.patch ];
      });

      hyprlock = prev.hyprlock.overrideAttrs (
        o:
        sources.hyprlock
        // {
          patches = [ ];

          buildInputs =
            o.buildInputs
            ++ (with prev; [
              file
              libjpeg
              libwebp
            ]);
        }
      );

      # add default font to silence null font errors
      lsix = prev.lsix.overrideAttrs (o: {
        postFixup = ''
          substituteInPlace $out/bin/lsix \
            --replace-fail '#fontfamily=Mincho' 'fontfamily="JetBrainsMono-NF-Regular"'
          ${o.postFixup}
        '';
      });

      # fix nix package count for nitch
      nitch = prev.nitch.overrideAttrs (o: {
        patches = (o.patches or [ ]) ++ [ ./nitch-nix-pkgs-count.patch ];
      });

      path-of-building =
        let
          desktopItem = pkgs.makeDesktopItem {
            name = "Path of Building";
            desktopName = "Path of Building";
            comment = "Offline build planner for Path of Exile";
            exec = "pobfrontend %U";
            terminal = false;
            type = "Application";
            icon = ./PathOfBuilding-logo.png;
            categories = [ "Game" ];
            keywords = [
              "poe"
              "pob"
              "pobc"
              "path"
              "exile"
            ];
            mimeTypes = [ "x-scheme-handler/pob" ];
          };
          data = prev.path-of-building.passthru.data.overrideAttrs sources.path-of-building;
        in
        prev.path-of-building.overrideAttrs {
          inherit (sources.path-of-building) version;

          postInstall = ''
            mkdir -p $out/share/applications
            cp ${desktopItem}/share/applications/* $out/share/applications
          '';

          preFixup = ''
            qtWrapperArgs+=(
              --set LUA_PATH "$LUA_PATH"
              --set LUA_CPATH "$LUA_CPATH"
              --chdir "${data}"
            )
          '';
        };

      scope-tui = prev.scope-tui.overrideAttrs (
        o:
        sources.scope-tui
        // {
          # do not copy custom cargo.lock
          postPatch = "";

          buildInputs = (o.buildInputs or [ ]) ++ [ prev.alsa-lib ];

          # creating an overlay for buildRustPackage overlay
          # https://discourse.nixos.org/t/is-it-possible-to-override-cargosha256-in-buildrustpackage/4393/3
          cargoDeps = prev.rustPlatform.importCargoLock {
            lockFile = sources.scope-tui.src + "/Cargo.lock";
            allowBuiltinFetchGit = true;
          };
        }
      );

      swww = prev.swww.overrideAttrs (
        sources.swww
        // {
          # creating an overlay for buildRustPackage overlay
          # https://discourse.nixos.org/t/is-it-possible-to-override-cargosha256-in-buildrustpackage/4393/3
          cargoDeps = prev.rustPlatform.importCargoLock {
            lockFile = sources.swww.src + "/Cargo.lock";
            allowBuiltinFetchGit = true;
          };
        }
      );

      wallust =
        assert (lib.assertMsg (prev.wallust.version == "2.10.0") "wallust: use wallust from nixpkgs?");
        prev.wallust.overrideAttrs (
          o:
          sources.wallust
          // {
            nativeBuildInputs = (o.nativeBuildInputs or [ ]) ++ [ prev.installShellFiles ];

            postInstall = ''
              installManPage man/wallust*
              installShellCompletion --cmd wallust \
                --bash completions/wallust.bash \
                --zsh completions/_wallust \
                --fish completions/wallust.fish
            '';

            # creating an overlay for buildRustPackage overlay
            # https://discourse.nixos.org/t/is-it-possible-to-override-cargosha256-in-buildrustpackage/4393/3
            cargoDeps = prev.rustPlatform.importCargoLock {
              lockFile = sources.wallust.src + "/Cargo.lock";
              allowBuiltinFetchGit = true;
            };
          }
        );
    })
  ];
}
