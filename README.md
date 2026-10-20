# jamestelfer/nixpkgs

Nix packages for projects published by @jamestelfer. Release automation publishes package definitions here.

## Install

Install a tool by name from the flake:

```sh
nix profile install github:jamestelfer/nixpkgs#<tool>
```

Run it without installing:

```sh
nix run github:jamestelfer/nixpkgs#<tool>
```

Upgrade to the latest release with `nix profile upgrade`.

To add the packages to a NixOS, nix-darwin or home-manager configuration, apply `overlays.default`. The packages then build from that configuration's own nixpkgs:

```nix
# flake inputs
inputs.jamestelfer-nixpkgs.url = "github:jamestelfer/nixpkgs";

# configuration
nixpkgs.overlays = [ inputs.jamestelfer-nixpkgs.overlays.default ];
```

Without flakes, install from `default.nix`:

```sh
nix-env -f https://github.com/jamestelfer/nixpkgs/archive/main.tar.gz -iA <tool>
```

Projects release different platforms. The flake lists each tool only under the systems its release has an archive for, built from nixpkgs 26.05.

## How packages arrive

Each project's goreleaser `nix:` publisher commits `pkgs/<tool>/default.nix` to `main` on every non-prerelease release. The recipe downloads the release archive for the current system and checks it against the hash computed at release time.

`flake.nix` and `default.nix` expose every directory under `pkgs/`, so a new tool needs no edit here. Nothing runs at publish time: Nix evaluates the flake when a user installs from it.

A recipe can depend on another package in this repository. List it under the goreleaser `nix:` block's `dependencies` and the recipe's wrapper puts it on the tool's PATH. Sandy does this with imds-broker. Publish the dependency first: if a recipe names a package that isn't here yet, the flake stops evaluating for every tool.

The `nixpkgs` flake input only supplies the build helpers the recipes use. Nothing here is published to nixpkgs itself.

Do not edit files under `pkgs/` by hand: the next release overwrites them.
