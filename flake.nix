{
  description = "Nix packages for projects published by @jamestelfer";

  # Supplies the build helpers the recipes use (stdenvNoCC, fetchurl,
  # installShellFiles). Nothing here is published to nixpkgs itself.
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { self, nixpkgs }:
    let
      # Platforms release automation builds archives for, less x86_64-darwin:
      # nixpkgs 26.11 dropped it and throws on evaluation. Intel Mac users on
      # an older nixpkgs can still use overlays.default, which builds from
      # their own package set.
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
    in
    {
      packages = forAllSystems (pkgs: import ./default.nix { inherit pkgs; });
      overlays.default = final: _prev: import ./default.nix { pkgs = final; };
    };
}
