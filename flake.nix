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

        v1_4_3_bin = pkgs.callPackage ./packages/duckdb-bin.nix {
          stdenv = pkgs.stdenv;
          version = "v1.4.3";
          sha256 = "sha256-AuMqby50oIgyI2vXDtfZnLfaj6628g8vWGy59l+5qWY=";
        };
        v1_4_3_lib = pkgs.callPackage ./packages/duckdb-lib.nix {
          stdenv = pkgs.stdenv;
          version = "v1.4.3";
          sha256 = "sha256-xSViVD7ad+osdvfntkAnA/MkybEfsQwGuYZMiZnqvAU=";
        };
        v1_4_3 = (pkgs.callPackage ./packages/v1.4.3.nix {
          stdenv = pkgs.stdenv;
        }).overrideAttrs (old: { doInstallCheck = false; });

        v1_4_2_bin = pkgs.callPackage ./packages/duckdb-bin.nix {
          stdenv = pkgs.stdenv;
          version = "v1.4.2";
          sha256 = "sha256-r5sGMoslkFFc+QMhcYnG1prUe6ehT0n99sdSHD6ztFE=";
        };
        v1_4_2_lib = pkgs.callPackage ./packages/duckdb-lib.nix {
          stdenv = pkgs.stdenv;
          version = "v1.4.2";
          sha256 = "sha256-W1YOf4zBQkkLxEGWyWg2dXJhWSzRrm+MWau9bvvMSQA=";
        };
        v1_4_2 = (pkgs.callPackage ./packages/v1.4.2.nix {
          stdenv = pkgs.stdenv;
        }).overrideAttrs (old: { doInstallCheck = false; });

        v1_4_1_bin = pkgs.callPackage ./packages/duckdb-bin.nix {
          stdenv = pkgs.stdenv;
          version = "v1.4.1";
          sha256 = "sha256-kqaTzG/RArMIXX6YWiARod1HEiUIZ1StSv9yWs4gGBs=";
        };
        v1_4_1_lib = pkgs.callPackage ./packages/duckdb-lib.nix {
          stdenv = pkgs.stdenv;
          version = "v1.4.1";
          sha256 = "sha256-Ss+ocxQ4TuRSGj/mnA3bD01unZlOL1s9dVEsnG6bM7o=";
        };
        v1_4_1 = (pkgs.callPackage ./packages/v1.4.1.nix {
          stdenv = pkgs.stdenv;
        }).overrideAttrs (old: { doInstallCheck = false; });

        v1_4_0_bin = pkgs.callPackage ./packages/duckdb-bin.nix {
          stdenv = pkgs.stdenv;
          version = "v1.4.0";
          sha256 = "sha256-Di5hkXyIZ3Ve4ibPF0DLZNlMEz7EOy8AJJcaepGxaX8=";
        };
        v1_4_0_lib = pkgs.callPackage ./packages/duckdb-lib.nix {
          stdenv = pkgs.stdenv;
          version = "v1.4.0";
          sha256 = "sha256-vRX2R/3+XTJg9paWq3eFYnF8nJqSOjIUyYE5QOhLZ4Y=";
        };
        v1_4_0 = (pkgs.callPackage ./packages/v1.4.0.nix {
          stdenv = pkgs.stdenv;
        }).overrideAttrs (old: { doInstallCheck = false; });
        
        v1_3_2_bin = pkgs.callPackage ./packages/duckdb-bin.nix {
          stdenv = pkgs.stdenv;
          version = "v1.3.2";
          sha256 = "51aVGzhmjEv+ISQS3eLvt9eAtZci9fiWHjcDOwC3b9E=";
        };
        v1_3_2_lib = pkgs.callPackage ./packages/duckdb-lib.nix {
          stdenv = pkgs.stdenv;
          version = "v1.3.2";
          sha256 = "5WATRk64xl1KnOGuv2KQ2BZscI2h6ShAbq/fbGj/1f0=";
        };
        v1_3_2 = (pkgs.callPackage ./packages/v1.3.2.nix {
          stdenv = pkgs.stdenv;
        }).overrideAttrs (old: { doInstallCheck = false; });
        
        v1_3_1_bin = pkgs.callPackage ./packages/duckdb-bin.nix {
          stdenv = pkgs.stdenv;
          version = "v1.3.1";
          sha256 = "4kCS/w1sfFHAxUO+YshxnMRlS3qfGCZwQEHcxlmwj5o=";
        };
        v1_3_1_lib = pkgs.callPackage ./packages/duckdb-lib.nix {
          stdenv = pkgs.stdenv;
          version = "v1.3.1";
          sha256 = "/sloxu/TterKroxGgal+t48AkS8S0qdRu8LQjyIbKhY=";
        };
        v1_3_1 = pkgs.callPackage ./packages/v1.3.1.nix {
          stdenv = pkgs.stdenv;
        };

        v1_3_0_bin = pkgs.callPackage ./packages/duckdb-bin.nix {
          stdenv = pkgs.stdenv;
          version = "v1.3.0";
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
        
        default = v1_4_3;
      };

      # nix fmt
      formatter = pkgs.alejandra;

      devShells.default = pkgs.mkShell {
        buildInputs = with packages; [
          v1_4_3_bin
          v1_4_3_lib
          #v1_4_2_bin
          #v1_4_2_lib
          #v1_4_1_bin
          #v1_4_1_lib
          #v1_4_0_bin
          #v1_4_0_lib
          # v1_3_1_bin
          # v1_3_1_lib
          # v1_3_1
          # v1_3_0_bin
          # v1_3_0_lib
          # v1_3_0
          # v1_2_0_bin
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
