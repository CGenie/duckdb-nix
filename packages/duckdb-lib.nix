{ lib
, stdenv
, fetchzip
, version ? "v1.3.0"
, sha256 ? "TcSUUx7lphIPtTzliI2K48vy/ng9Odfgxinnyv81QHU="
}:

# https://github.com/duckdb/duckdb/releases/download/v1.3.0/libduckdb-linux-amd64.zip

stdenv.mkDerivation {
  inherit version;
  name = "duckdb";
  src = fetchzip {
    inherit sha256;
    url = "https://github.com/duckdb/duckdb/releases/download/${version}/libduckdb-linux-amd64.zip";
    stripRoot = false;
  };
  phases = ["installPhase" "patchPhase"];
  installPhase = ''
    mkdir -p $out/src
    mkdir -p $out/lib
    cp $src/duckdb.h $out/src/
    cp $src/libduckdb.so $out/lib/
    cp $src/libduckdb_static.a $out/lib/
    echo $out
  '';
}
