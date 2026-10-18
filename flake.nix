{
  description = "Nix packages for projects published by @jamestelfer";

  # Supplies the build helpers the recipes use (stdenvNoCC, fetchurl,
  # installShellFiles). Nothing here is published to nixpkgs itself.
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

  outputs =
    { self, nixpkgs }:
    let
      inherit (nixpkgs) lib;
      # Every platform goreleaser's nix publisher can emit. nixpkgs 26.05 is
      # the last release supporting x86_64-darwin; drop it when moving past it.
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "i686-linux"
        "armv6l-linux"
        "armv7l-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = f: lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
    in
    {
      # Projects release different platforms, so each system only lists the
      # tools whose recipe (meta.platforms) has an archive for it.
      packages = forAllSystems (
        pkgs:
        lib.filterAttrs (_: pkg: lib.meta.availableOn pkgs.stdenv.hostPlatform pkg) (
          import ./default.nix { inherit pkgs; }
        )
      );
      overlays.default = final: _prev: import ./default.nix { pkgs = final; };
    };
}
