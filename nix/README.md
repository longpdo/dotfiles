# Nix

user: longdo

Install dependencies:
xcode-select --install

Install Determinate Nix:
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

Clone Repo:
mkdir -p ~/dev
cd ~/dev
git clone <your-repo-url>
cd dotfiles/nix

First nix run:
nix run nix-darwin -- switch --flake .#mac

After each flake update:
cd ~/dev/mac-config
darwin-rebuild switch --flake .#mac
