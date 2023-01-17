{ pkgs ? import <nixpkgs> {  } }:
let
  release = builtins.fromJSON (builtins.readFile ./release.json);
  artifact = pkgs.fetchurl release.artifacts.${pkgs.system};
in
  pkgs.stdenv.mkDerivation {
    pname = "nocodb";
    version = release.version;

    dontStrip = true;
    unpackPhase = "cp ${artifact} ./nocodb";

    installPhase = ''
      install -Dm755 ./nocodb -t $out/bin
    '';
  }