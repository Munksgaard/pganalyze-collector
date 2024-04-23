{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs@{ self, nixpkgs, flake-parts, ... }:
    let
      name = "pganalyze-collector";
      pname = name;
      version = "0.55.0";
      sha256 = "sha256-RBlf71UG1M1f341H86fV+Rsub5PCrX40avcXWwjiaAU=";

    in flake-parts.lib.mkFlake { inherit inputs; } {
      systems =
        [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      perSystem = { config, self', inputs', pkgs, system, ... }: {
        packages.pganalyze-collector = with pkgs;
          buildGoModule {
            inherit pname version;
            vendorHash = null;
            src = fetchFromGitHub {
              owner = "pganalyze";
              repo = "collector";
              rev = "v${version}";
              inherit sha256;
              fetchSubmodules = true;
            };

            buildInputs = [
              (protobuf3_20.override {
                version = "3.14.0";
                sha256 = "sha256-RA3qtADLgrtd9ktMXQM9nw3/xz4AXs3FOH+1ic6ak8w=";
              })
            ];
          };
        packages.default = self'.packages.pganalyze-collector;
      };
    };
}
