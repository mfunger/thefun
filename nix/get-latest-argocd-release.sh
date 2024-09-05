#! /usr/bin/env nix-shell
#! nix-shell -i bash --pure
#! nix-shell -p bash cacert curl jq python3Packages.xmljson figlet cowsay
#! nix-shell -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/2a601aafdc5605a5133a2ca506a34a3a73377247.tar.gz

cowsay "Getting the latest version info for ArgoCD"
curl -s -L  -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" https://api.github.com/repos/argoproj/argo-cd/releases/latest > latest-argocd.json;
figlet -f small "Got it! \n\n\n"
figlet -f small "Parsing for info...\n"
cat latest-argocd.json | jq -r '{Version: .name, "Published Date": .published_at, ID: .id}'

figlet "Getting the latest version info for Argo Helm" 
curl -s -L  -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" https://api.github.com/repos/argoproj/argo-helm/releases/latest > latest-argohelm.json;
figlet "Got it!"
figlet "Parsing for info..."
cat latest-argocd.json | jq -r '{Version: .name, "Published Date": .published_at, ID: .id}'
