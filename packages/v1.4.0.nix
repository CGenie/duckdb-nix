# A shameless copy from nixpkgs/pkgs/development/libraries/duckdb/

{ lib
, stdenv
, fetchFromGitHub
, cmake
, ninja
, openssl
, openjdk11
, python3
, unixODBC
, withJdbc ? false
, withOdbc ? false
}:

let
  enableFeature = yes: if yes then "ON" else "OFF";
  versions = {
      version = "1.4.0";
      rev = "b8a06e4a22672e254cd0baa68a3dbed2eb51c56e";
      hash = "sha256-ywQU+G8+VF+CiCb0Kgnx9cqKBBUEs4JG0iqh/OQS980=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "duckdb";
  inherit (versions) rev version;

  src = fetchFromGitHub {
    # to update run:
    # nix-shell maintainers/scripts/update.nix --argstr path duckdb
    inherit (versions) hash;
    owner = "duckdb";
    repo = "duckdb";
    rev = "refs/tags/v${finalAttrs.version}";
  };

  outputs = [ "out" "lib" "dev" ];

  nativeBuildInputs = [ cmake ninja python3 ];
  buildInputs = [ openssl ]
    ++ lib.optionals withJdbc [ openjdk11 ]
    ++ lib.optionals withOdbc [ unixODBC ];

  cmakeFlags = [
    "-DDUCKDB_EXTENSION_CONFIGS=${finalAttrs.src}/.github/config/in_tree_extensions.cmake"
    "-DBUILD_ODBC_DRIVER=${enableFeature withOdbc}"
    "-DJDBC_DRIVER=${enableFeature withJdbc}"
    "-DOVERRIDE_GIT_DESCRIBE=v${finalAttrs.version}-0-g${finalAttrs.rev}"
  ] ++ lib.optionals finalAttrs.doInstallCheck [
    # development settings
    "-DBUILD_UNITTESTS=ON"
  ];

  doInstallCheck = true;

  installCheckPhase =
    let
      excludes = map (pattern: "exclude:'${pattern}'") ([
        "test/sql/table_function/read_text_and_blob.test"
      ]);
      LD_LIBRARY_PATH = lib.optionalString stdenv.hostPlatform.isDarwin "DY" + "LD_LIBRARY_PATH";
    in
    ''
      runHook preInstallCheck
      (($(ulimit -n) < 1024)) && ulimit -n 1024

      HOME="$(mktemp -d)" ${LD_LIBRARY_PATH}="$lib/lib" ./test/unittest ${toString excludes}

      runHook postInstallCheck
    '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    changelog = "https://github.com/duckdb/duckdb/releases/tag/v${finalAttrs.version}";
    description = "DuckDB is an analytical in-process SQL database management system";
    homepage = "https://duckdb.org/";
    license = licenses.mit;
    mainProgram = "duckdb";
    maintainers = with maintainers; [ costrouc cpcloud ];
    platforms = platforms.all;
  };
})
