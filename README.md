# mobian-recipes

A set of [debos](https://github.com/go-debos/debos) recipes for building a
debian-based image for mobile phones, specifically targetting msm8974 Phones.

The default user is `mobian` with password `1234`.

## Build

To build the image, you need to have `debos` and `bmaptool`. On a debian-based
system, install these dependencies by typing the following command in a terminal:

```
sudo apt install debos bmap-tools android-sdk-libsparse-utils xz-utils f2fs-tools
```

Do note that the debos provided in Debian 10 (Buster) is not new enough
(it will error out with "Unknown action: recipe"), the one in Debian
Bullseye works.
If you want to build with EXT4 filesystem f2fs-tools is not required.

The build system will cache and re-use it's output files. To create a fresh build
remove `*.tar.gz`, `*.sqfs` and `*.img` before starting the build.

If your system isn't debian-based (or if you choose to install `debos` without
using `apt`, which is a terrible idea), please make sure you also install the
following required packages:
- `debootstrap`
- `qemu-user-static`
- `binfmt-support`
- `squashfs-tools-ng` (only required for generating installer images)

Then simply browse to the `mobian-recipes` folder and execute `./build.sh`.

You can use `./build.sh -d` to use the docker version of `debos`.

## Install

Connect your phone on fastboot mode into your computer, and type the following command:

```
fastboot flash boot <boot>
fastboot flash userdata <root>
```


*Note: Make sure to use the actual image, not
`<root> / <boot>`.*

**CAUTION: This will format the device!!!**

## Contributing

If you want to help with this project, please have a look at the
[roadmap](https://wiki.debian.org/Teams/Mobian/Roadmap) and
[open issues](https://salsa.debian.org/groups/Mobian-team/-/issues).

[#mobian:matrix.org](https://matrix.to/#/#mobian:matrix.org).

# License

This software is licensed under the terms of the GNU General Public License,
version 3.
