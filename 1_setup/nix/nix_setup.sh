/usr/bin/env zsh

bash <(curl -L https://nixos.org/nix/install) --daemon;


# upgrade nix
# sudo -i sh -c 'nix-channel --update && nix-env --install --attr nixpkgs.nix && launchctl remove org.nixos.nix-daemon && launchctl load /Library/LaunchDaemons/org.nixos.nix-daemon.plist'