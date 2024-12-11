#! /usr/bin/env bash
# We're installing Nix and nix-darwin (via Flake)

# Install the determinate systems version of Nix, because it has an uninstaller.
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | \
  sh -s -- install

# Creating flake.nix
# https://github.com/LnL7/nix-darwin?tab=readme-ov-file#getting-started
mkdir -p ~/.config/nix-darwin
cd ~/.config/nix-darwin
nix flake init -t nix-darwin
sed -i '' "s/simple/$(scutil --get LocalHostName)/" flake.nix

# installing nix-darwin
nix run nix-darwin -- switch --flake ~/.config/nix-darwin

# using nix-darwin
darwin-rebuild switch --flake ~/.config/nix-darwin