# Ubuntu build and desktop integration

The build, user installation, and desktop UI registration are intentionally
separate:

```sh
./scripts/build-ubuntu.sh
./scripts/install-user.sh
./scripts/register-linux-desktop.sh
```

`build-ubuntu.sh` installs build dependencies unless `--skip-deps` is passed.
The user install uses `~/.local/share/aseprite` and adds a launcher symlink at
`~/.local/bin/aseprite`; it does not require root access. Desktop registration
uses the XDG user directories and can be removed independently:

```sh
./scripts/register-linux-desktop.sh --unregister
```

Override `ASEPRITE_BUILD_DIR`, `ASEPRITE_INSTALL_DIR`, or `ASEPRITE_BIN_DIR`
when non-default locations are needed.
