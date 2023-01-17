# nix-nocodb
Nix flake + derivation for nocodb

https://www.nocodb.com/

```shell
nix shell github:jmoo/nix-nocodb -c nocodb
```

#### Generate release.json
```shell
# Get latest version from github releases atom feed
./generate.sh

# Specify version
./generate.sh 0.101.2
```