{ lib
, stdenv
, fetchzip
, version ? "v1.3.0"
, sha256 ? "+gW5sBlPkuZT4F9eCKbA9FO4c/bbwLwbOwZuMUxVjHg="
}:

# https://github.com/duckdb/duckdb/releases/download/v1.2.2/duckdb_cli-linux-amd64.gz
# https://github.com/duckdb/duckdb/releases/download/v1.3.0/duckdb_cli-linux-amd64.zip

stdenv.mkDerivation {
  inherit version;
  name = "duckdb";
  src = fetchzip {
    inherit sha256;
    url = "https://github.com/duckdb/duckdb/releases/download/${version}/duckdb_cli-linux-amd64.zip";
  };
  phases = ["installPhase" "patchPhase"];
  installPhase = ''
    mkdir -p $out/bin
    cp $src/duckdb $out/bin/duckdb
    chmod +x $out/bin/duckdb
    echo $out
  '';
}
