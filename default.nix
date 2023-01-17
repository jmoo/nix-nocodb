{ pkgs ? import <nixpkgs> {  } }:
let
  semver = "0.101.2";

  archs = {
    x86_64-linux = {
      url = "https://github.com/nocodb/nocodb/releases/download/${semver}/Noco-linux-x64";
      sha256 = "sha256-qibwumlCC2gLgSLAr0czTtvuIk4HEgOrRgZtrqw9gRQ=";
    };

    aarch64-linux = {
     url = "https://github.com/nocodb/nocodb/releases/download/${semver}/Noco-linux-arm64";
     sha256 = "sha256-dm0xxvpzMJsOI921VA4blvJlsqr8EXbX4ENbJwbckC4=";
   };

    x86_64-darwin =  {
      url = "https://github.com/nocodb/nocodb/releases/download/${semver}/Noco-macos-x64";
      sha256 = "sha256-MFLJ36pyRorhUqvLh+NevcIItoJ93rptBupLQQ+ozlo=";
    };

    aarch64-darwin = {
     url = "https://github.com/nocodb/nocodb/releases/download/${semver}/Noco-macos-arm64";
     sha256 = " sha256-QL9TxKLwneniJa6xVg8B291vUgJx1lJzhYfF38j+vgU=";
   };
  };

  bin = pkgs.fetchurl archs.${pkgs.system};
in
  pkgs.stdenv.mkDerivation {
    pname = "nocodb";
    version = semver;

    dontStrip = true;
    unpackPhase = "cp ${bin} ./nocodb";

    installPhase = ''
      ls -la
      install -Dm755 ./nocodb -t $out/bin
      #mv ./lib $out/lib
    '';
  }