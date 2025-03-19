{
  description = "DGSA project dev shell with Python 3.8 and uv";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        python = pkgs.python38;

        uv = pkgs.stdenv.mkDerivation {
          pname = "uv";
          version = "0.1.28"; # 这里用 uv 的稳定版本

          src = pkgs.fetchurl {
            url = "https://github.com/astral-sh/uv/releases/download/0.1.28/uv-x86_64-unknown-linux-gnu.tar.gz";
            sha256 = "sha256-91uhthg6r44v8ap5pd6jqz66zx55idp51l2v40fdhplpkzqk65yi";
          };

          phases = [ "installPhase" ];

          installPhase = ''
            mkdir -p $out/bin
            tar -xzf $src -C $out/bin
            chmod +x $out/bin/uv
          '';
        };
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            python
            uv
          ];

          shellHook = ''
            export PYTHONNOUSERSITE="true"
            export VIRTUAL_ENV=.venv
            echo "✅ Python 3.8 + uv dev shell ready"

            alias python=python3.8
          '';
        };
      });
}

