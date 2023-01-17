{
  description = ''
    NocoDB is an open source #NoCode platform that turns any database into a smart spreadsheet.
  '';

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
    in (flake-utils.lib.eachSystem systems (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in rec {
        packages = rec {
          default = import ./default.nix { inherit pkgs; };
        };
      }
    ));
}