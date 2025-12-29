# Cryptomator Flatpak Repository

This repo contains the build manifest for the Flatpak flavor of [Cryptomator](https://cryptomator.org).

## Releases

Stable releases are found on [flathub](https://flathub.org/en/apps/org.cryptomator.Cryptomator).

To try beta releases:
1. Add flathub-beta to your system:
  ```
  flatpak remote-add --if-not-exists flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo
  ```
2. Install cryptomator:
  ```
  flatpak install flathub-beta org.cryptomator.Cryptomator
  ```
## Build

For building, the [flatpak-builder](https://docs.flatpak.org/en/latest/flatpak-builder.html) is required.
Change to the repository root dir and run:
```
flatpak-builder --force-clean --install-deps-from=flathub build org.cryptomator.Cryptomator.yaml
```
The command builds the flatpak into the  `.\build` directory. For installation on the system, read the flatpak-builder documentation.
