{
  lib,
  stdenv,
  fetchFromGitHub,
  substituteAll,
  cmake,
  ninja,
  openssl,
  openjdk11,
  python3,
  unixODBC,
  libcxx,
  withJdbc ? false,
  withOdbc ? false,
  specialArgs ? {},
}: let
  defaultArgs = {
    pname = "duckdb";
    version = "1.1.2";
    hash = "sha256-JoGGnlu2aioO6XbeUZDe23AHSBxciLSEKBWRedPuXjI=";
  };
  args = defaultArgs // specialArgs;
  enableFeature = yes:
    if yes
    then "ON"
    else "OFF";
in
  stdenv.mkDerivation rec {
    pname = args.pname;
    version = args.version;

    src = fetchFromGitHub {
      owner = args.pname;
      repo = args.pname;
      rev = "refs/tags/v${args.version}";
      hash = args.hash;
    };

    # patches = [
    #   # remove calls to git and set DUCKDB_VERSION to version
    #   (substituteAll {
    #     src = ./v${args.version}.patch;
    #     version = "v${args.version}";
    #   })
    # ];

    nativeBuildInputs = [
      cmake
      ninja
      #python3
    ];

    buildInputs =
      [
        openssl
      ]
      ++ lib.optionals (stdenv.isLinux) [
        libcxx
      ]
      ++ lib.optionals withJdbc [openjdk11]
      ++ lib.optionals withOdbc [unixODBC];

    cmakeFlags =
      [
        #"-DCMAKE_CXX_COMPILER_LAUNCHER=ccache"
        "-DDUCKDB_EXTENSION_CONFIGS=${src}/.github/config/in_tree_extensions.cmake"
        "-DBUILD_ODBC_DRIVER=${enableFeature withOdbc}"
        "-DJDBC_DRIVER=${enableFeature withJdbc}"
      ]
      ++ lib.optionals doInstallCheck [
        # development settings
        "-DBUILD_UNITTESTS=ON"
      ];

    doInstallCheck = true;

    preInstallCheck =
      ''
        export HOME="$(mktemp -d)"
      ''
      + lib.optionalString stdenv.isDarwin ''
        export DYLD_LIBRARY_PATH="$out/lib''${DYLD_LIBRARY_PATH:+:}''${DYLD_LIBRARY_PATH}"
      '';

    installCheckPhase = let
      excludes = map (pattern: "exclude:'${pattern}'") ([
        "test/parquet/parquet_long_string_stats.test"
        "test/sql/attach/attach_remote.test"
        "test/sql/copy/csv/test_sniff_httpfs.test"
        "test/sql/httpfs/internal_issue_2490.test"
        
        # some connection issues?
        "test/db-benchmark/groupby.test_slow"
        "test/db-benchmark/join.test_slow"

        "test/sql/copy/csv/parallel/csv_parallel_httpfs.test"
        "test/sql/copy/csv/test_limit_spinlock.test_slow"
        "test/sql/copy/csv/test_mixed_lines.test_slow"
        "test/sql/copy/parquet/delta_byte_array_length_mismatch.test"
        "test/sql/copy/parquet/delta_byte_array_multiple_pages.test"
        "test/sql/copy/parquet/parquet_2102.test_slow"
        "test/sql/copy/parquet/parquet_5968.test"
        "test/sql/copy/parquet/parquet_boolean_page.test_slow"
        "test/sql/copy/parquet/snowflake_lineitem.test"
        "test/sql/copy/parquet/test_parquet_force_download.test"
        "test/sql/copy/parquet/test_parquet_remote.test"
        "test/sql/copy/parquet/test_parquet_remote_foreign_files.test"
        "test/sql/copy/parquet/test_yellow_cab.test_slow"
        "test/sql/table_function/read_text_and_blob.test"
        ]
        ++ lib.optionals stdenv.isAarch64 [
          "test/sql/aggregate/aggregates/test_kurtosis.test"
          "test/sql/aggregate/aggregates/test_skewness.test"
          "test/sql/function/list/aggregates/skewness.test"
        ]);
    in ''
      runHook preInstallCheck

      # turn off tests
      # ./test/unittest ${toString excludes}

      runHook postInstallCheck
    '';

    postInstall = ''
      mkdir -p $out/third_party
      cp -r $src/third_party/* $out/third_party
      # TODO:
      # - fix parent copy permission error
      # cd $src/third_party
      # cp -r --parents **/{*.h,*.hpp,LICENSE} $out/third_party
      # cd -
    '';

    meta = with lib; {
      changelog = "https://github.com/duckdb/duckdb/releases/tag/v${version}";
      description = "Embeddable SQL OLAP Database Management System";
      homepage = "https://duckdb.org/";
      license = licenses.mit;
      mainProgram = "duckdb";
      maintainers = with maintainers; [costrouc cpcloud];
      platforms = platforms.all;
    };
  }
