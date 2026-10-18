{
  description = "Nix packages for projects published by @jamestelfer";

  # Supplies the build helpers the recipes use (stdenvNoCC, fetchurl,
  # installShellFiles). Nothing here is published to nixpkgs itself.
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

  outputs =
    { self, nixpkgs }:
    let
      # The platforms release automation builds archives for. nixpkgs 26.05 is
      # the last release supporting x86_64-darwin; drop it when moving past it.
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
    in
    {
      packages = forAllSystems (pkgs: import ./default.nix { inherit pkgs; });
      overlays.default = final: _prev: import ./default.nix { pkgs = final; };
    };
}
