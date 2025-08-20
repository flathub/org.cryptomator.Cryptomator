#!/usr/bin/env bash

# update.sh - Script to update the Cryptomator Flatpak maven dependencies
# Requires yq and natsort to be installed

set -e

# clean up previous builds
rm -rf .flatpak-builder/ build/ repo

# patch the yml file
## This allows the Flatpak to access the network, which is required to update maven dependencies
yq '(.modules[] | select(.name == "cryptomator") | .build-options.build-args) = ["--share=network"]' -i org.cryptomator.Cryptomator.yaml
## Remove the maven dependency files from the sources list
yq '(.modules[] | select(.name == "cryptomator") | .sources) |= map(select( . == "maven*" | not))' -i org.cryptomator.Cryptomator.yaml

# Build the Flatpak package
flatpak-builder --force-clean --install-deps-from=flathub --build-only --keep-build-dirs build org.cryptomator.Cryptomator.yaml

# Update maven dependencies
## Update arch independent dependencies
( cd .flatpak-builder/build/*-1/.m2/repository/             \
 && find * -type f \( -iname '*.jar' -o -iname '*.pom' \)   \
 | grep -v 'javafx-*-linux-*.jar'                           \
 | natsort -p                                               \
 | xargs -rI '{}' bash -c                                   \
 'echo -e "- type: file\n  dest: .m2/repository/$(dirname {})\n  url: https://repo.maven.apache.org/maven2/{}\n  sha256: $(sha256sum {} | cut -c 1-64)"' \
 ) > maven-dependencies.yaml

## Update x86_64 arch dependencies
( cd .flatpak-builder/build/*-1/.m2/repository/         \
 && find * -type f \( -iname 'javafx-*-linux.jar' \)    \
 | natsort -p                                           \
 | xargs -rI '{}' bash -c                               \
 'echo -e "- type: file\n  dest: .m2/repository/$(dirname {})\n  url: https://repo.maven.apache.org/maven2/{}\n  sha256: $(sha256sum {} | cut -c 1-64)\n  only-arches: [x86_64]"' \
 ) > maven-dependencies-x86_64.yaml


## Update aarch64 arch dependencies :-P
echo "WARNING: JavaFX AARCH64 dependencies are not updated automatically."
echo "Please update them manually."

# revert the yml file to its original state
git checkout org.cryptomator.Cryptomator.yaml
