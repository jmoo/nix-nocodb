#!/usr/bin/env bash
set -eo pipefail
feed="https://github.com/nocodb/nocodb/releases.atom"
version="$1"

if [[ "$version" = "" ]]; then
  echo "Fetching latest version with rsstail ($feed)..." 1>&2
  echo "(use './generate.sh VERSION' to specify a version instead)" 1>&2

  version="$(
    nix shell 'nixpkgs#rsstail' -c rsstail -u "$feed" -HN1 |
      sed -E 's/[ ]*([^:]+).*/\1/' |
      head -n 1
  )"
fi

echo "Using version: [$version]" 1>&2
echo "Calculating hashes..." 1>&2

x86_64_linux_url="https://github.com/nocodb/nocodb/releases/download/${version}/Noco-linux-x64"
x86_64_linux_hash="$(nix-prefetch-url "${x86_64_linux_url}" --type sha256 | xargs nix hash to-sri --type sha256)"
echo "$x86_64_linux_url -> $x86_64_linux_hash" 1>&2

aarch64_linux_url="https://github.com/nocodb/nocodb/releases/download/${version}/Noco-linux-arm64"
aarch64_linux_hash="$(nix-prefetch-url "${aarch64_linux_url}" --type sha256 | xargs nix hash to-sri --type sha256)"
echo "$aarch64_linux_url -> $aarch64_linux_hash" 1>&2

x86_64_darwin_url="https://github.com/nocodb/nocodb/releases/download/${version}/Noco-macos-x64"
x86_64_darwin_hash="$(nix-prefetch-url "${x86_64_darwin_url}" --type sha256 | xargs nix hash to-sri --type sha256)"
echo "$x86_64_darwin_url -> $x86_64_darwin_hash" 1>&2

aarch64_darwin_url="https://github.com/nocodb/nocodb/releases/download/${version}/Noco-macos-arm64"
aarch64_darwin_hash="$(nix-prefetch-url "${aarch64_darwin_url}" --type sha256 | xargs nix hash to-sri --type sha256)"
echo "$aarch64_darwin_url -> $aarch64_darwin_hash" 1>&2

echo "Generating release.json..." 1>&2
nix shell 'nixpkgs#jq' -c jq --null-input "$(cat <<EOF
{
  "version": "$version",
  "artifacts": {
    "x86_64-linux": {
      "url": "$x86_64_linux_url",
      "sha256": "$x86_64_linux_hash"
    },
    "aarch64-linux": {
      "url": "$aarch64_linux_url",
      "sha256": "$aarch64_linux_hash"
    },
    "x86_64-darwin": {
      "url": "$x86_64_darwin_url",
      "sha256": "$x86_64_darwin_hash"
    },
    "aarch64-darwin": {
      "url": "$aarch64_darwin_url",
      "sha256": "$aarch64_darwin_hash"
    }
  }
}
EOF
)" > ./release.json

cat ./release.json 1>&2