# The Mystic Realm: Community Edition
Welcome! This repository contains:
- The latest version of the mod
- Issues related to the mod
- Progress tracking for the mod
- Mapping prefabs for Zone Builder
- The rest of the game files, ready for editing (maps, scripts, etc.)

## Contributing to MRCE
You can contribute your work to MRCE by submitting merge requests [to our GitLab page](https://gitlab.com/team-prismatic/mystic-realm-ce/-/merge_requests) (the preferred medium) or via the community [Discord server](https://discord.gg/WcB2vaqbgf) in the `#submissions` channel for peer review.

## Building MRCE

### Windows
Run `build_MRCE.bat` to create a `.pk3` that can be loaded through SRB2. It's as simple as that! Alternatively, zipping up the files within the `/src` directory and renaming the resulting file with a `.pk3` extension will suffice.

It's worth noting that it will also search through `/src` to remove the `.lmp` extension from Doom lump files, which may take some time if there's a lot of them - slow computers might take a second, so be patient!


### Linux/macOS
NOTE: You will need 7z installed on your system for this to work. On macOS this can be found inside MacPorts or Homebrew.

- Open a terminal and navigate to the source folder
- Run `create_pk3.sh` and load the addon through SRB2

NOTE: Unlike the Windows `build_MRCE.bat`, this script WON'T remove .lmp from files. It also doesn't make clean builds, so you might have to delete the `.pk3` if the build isn't coming out right.
