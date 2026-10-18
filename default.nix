# Package set for non-flake users. Every directory under ./pkgs is a package:
# release automation (goreleaser) writes pkgs/<name>/default.nix, so a new tool
# needs no edit here.
{
  pkgs ? import <nixpkgs> { },
}:
let
  inherit (pkgs) lib;
  names = lib.attrNames (lib.filterAttrs (_: type: type == "directory") (builtins.readDir ./pkgs));
in
lib.genAttrs names (name: pkgs.callPackage ./pkgs/${name} { })
