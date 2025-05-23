{
  description = "Nix flake for DuckDB";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }: let
    systems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
    outputs = flake-utils.lib.eachSystem systems (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          self.overlay
        ];
      };
    in rec {
      # packages exported by the flake
      packages = rec {
        main = pkgs.callPackage ./packages/main.nix {
          stdenv = pkgs.libcxxStdenv;
        };
        v1_3_0_bin = pkgs.callPackage ./packages/duckdb-bin.nix {
          stdenv = pkgs.stdenv;
          version = "v.1.3.0";
          sha256 = "+gW5sBlPkuZT4F9eCKbA9FO4c/bbwLwbOwZuMUxVjHg=";
        };
        v1_3_0_lib = pkgs.callPackage ./packages/duckdb-lib.nix {
          stdenv = pkgs.stdenv;
          version = "v1.3.0";
          sha256 = "TcSUUx7lphIPtTzliI2K48vy/ng9Odfgxinnyv81QHU=";
        };
        v1_3_0 = pkgs.callPackage ./packages/v1.3.0.nix {
          stdenv = pkgs.stdenv;
        };
        v1_2_2_bin = pkgs.callPackage ./packages/duckdb-bin.nix {
          stdenv = pkgs.stdenv;
          version = "v1.2.2";
          sha256 = "0erAOhxDLWZ2E7UNLlW5A20qXxJVFjn20/6lsTX+kLY=";
        };
        v1_2_2 = pkgs.callPackage ./packages/v1.2.2.nix {
          stdenv = pkgs.stdenv;
        };
        v1_2_1 = pkgs.callPackage ./packages/v1.2.1.nix {
          stdenv = pkgs.stdenv;
        };
        v1_2_0 = pkgs.callPackage ./packages/v1.2.0.nix {
          stdenv = pkgs.stdenv;
        };
        v1_1_3 = pkgs.callPackage ./packages/v1.1.3.nix {
          stdenv = pkgs.stdenv;
        };
        default = v1_2_0;
      };

      # nix fmt
      formatter = pkgs.alejandra;

      devShells.default = pkgs.mkShell {
        buildInputs = with packages; [
          v1_3_0_bin
          v1_3_0_lib
          v1_3_0
          v1_2_0_bin
        ];
      };
    });
  in
    outputs
    // {
      # Overlay that can be imported so you can access the packages
      # using duckdb-nix.overlay
      overlay = final: prev: {
        duckdb-pkgs = outputs.packages.${prev.system};
      };

      # nix flake init -t github:rupurt/duckdb-nix#multi
      templates = rec {
        multi = {
          description = "Multi version DuckDB template";
          path = ./templates/multi;
        };
        default = multi;
      };
    };
}
