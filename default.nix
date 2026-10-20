# Package set for non-flake users. Every directory under ./pkgs is a package:
# release automation (goreleaser) writes pkgs/<name>/default.nix, so a new tool
# needs no edit here.
#
# The set is a fixed point so a recipe can take a sibling package as a
# callPackage argument (goreleaser's nix `dependencies`, e.g. sandy wrapping
# imds-broker onto its PATH), alongside anything from nixpkgs.
#
# `lib` is a separate argument so the overlay can pass a lib that doesn't come
# from `final`; taking it from `final` makes the attribute names recurse.
{
  pkgs ? import <nixpkgs> { },
  lib ? pkgs.lib,
}:
let
  names = lib.attrNames (lib.filterAttrs (_: type: type == "directory") (builtins.readDir ./pkgs));
in
lib.fix (self: lib.genAttrs names (name: lib.callPackageWith (pkgs // self) ./pkgs/${name} { }))
