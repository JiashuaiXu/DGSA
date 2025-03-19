{
  description = "DGSA dev shell with Python 3.8 + uv (compiled from source)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        python = pkgs.python38;

        uv = pkgs.rustPlatform.buildRustPackage rec {
          pname = "uv";
          version = "0.1.28";

          src = pkgs.fetchFromGitHub {
            owner = "astral-sh";
            repo = "uv";
            rev = "v${version}";
            sha256 = "sha256-3TAzJW3qzUsZHG6DbRO1JLH4Q6C1rwzLBqIbIPUDmAk=";
          };

          cargoSha256 = "sha256-3WmFF7bY9jA9oow8waUQx6UsJ3U6fdGRUCPH7b1Sm2s=";
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
            echo "✅ Python 3.8 + uv (build from source) dev shell ready"

            alias python=python3.8
          '';
        };
      });
}

