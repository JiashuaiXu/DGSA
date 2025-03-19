{
  description = "DGSA project dev shell with Python 3.8 and PyTorch 1.3";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        python = pkgs.python38;
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            python
            pkgs.uv
          ];

          shellHook = ''
            export PYTHONNOUSERSITE="true"
            export VIRTUAL_ENV=.venv
            echo "🟢 Python 3.8 + uv dev shell ready"

            alias python=python3.8
          '';
        };
      });
}

