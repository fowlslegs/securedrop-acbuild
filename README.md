# SecureDrop acbuild

This repo is a PoC that builds a ACI container for SecureDrop.

## Building the ACI

```
git clone https://github.com/fowlslegs/securedrop-acbuild
cd securedrop/acbuild
sudo ./build-securedrop.sh
```

## Building the acbuild-specific SecureDrop .deb:

```
cd securedrop-acbuild/securedrop
vagrant up build
```

The `.deb` should appear under the `securedrop/builds/` directory.
