# gentoo-dots

configuration for lychee, an amd64 gentoo desktop: hardened 23.0 profile, ninit as pid 1, sway on wayland, foot, emacs, a 7.3.1 kernel built with clang and lld

comments are stripped from every file except the ones listed under verbatim files

## layout

| path | installs to |
| --- | --- |
| `home/` | `~` |
| `system/` | `/` (`etc`, `boot`, `usr/local/bin`) |
| `gentoo/portage/` | `/etc/portage` |
| `gentoo/world` | `/var/lib/portage/world` |
| `gentoo/kernel/config-7.3.1-lychee` | `/usr/src/linux/.config` |

## restore

### disks

- one btrfs filesystem with the subvolumes `@` on `/`, `@home` on `/home`, `@gentoo-portage` on `/var/tmp/portage` and `@swap` on `/swap`, which holds `swapfile`
- a vfat esp on `/boot`
- an xfs disk on `/srv/music`, mounted by the ninit service `musicmnt`

the uuids in `system/etc/fstab` and `system/etc/ninit.d/musicmnt`, the partuuid in `system/boot/loader/entries/` and the disk id in `home/.local/bin/media-to-exfat` belong to the old disks. replace them with the values `blkid` and `ls /dev/disk/by-id` report

### portage

unpack a hardened amd64 openrc stage3 and chroot into it. `make.conf` links with mold and `repos.conf` syncs over git, so both are installed before the configuration is copied

```sh
emerge-webrsync
emerge --oneshot dev-vcs/git sys-devel/mold
cp -rP --preserve=mode gentoo/portage/. /etc/portage/
install -Dm644 gentoo/world /var/lib/portage/world
rm -rf /var/db/repos/gentoo
emaint sync -a
emerge -uDN @world
emerge --depclean
```

- `-march=native` and `CPU_FLAGS_X86` match a ryzen 5 9600x. on other hardware, regenerate `CPU_FLAGS_X86` with `cpuid2cpuflags`
- `profile/packages` removes openrc and sysvinit from the system set
- `sys-apps/ninit` comes from the `nburch` overlay
- `package.mask/rust` keeps `dev-lang/rust` out so that `dev-lang/rust-bin` satisfies everything
- `env/buildpkg.conf` keeps binary packages of the long builds listed in `package.env`

### kernel

the source is the linux 7.3.1 tarball from kernel.org, unpacked to `/usr/src/linux-7.3.1`

```sh
cp gentoo/kernel/config-7.3.1-lychee /usr/src/linux-7.3.1/.config
cd /usr/src/linux-7.3.1
make LLVM=1 olddefconfig
make LLVM=1 -j12
make LLVM=1 modules_install install
```

- there is no initramfs, amdgpu is built in and the firmware comes from `sys-kernel/linux-firmware`, trimmed by its savedconfig
- `CONFIG_IKCONFIG` is off, so `/boot/config-VERSION`, written by `sys-kernel/installkernel`, is the only record of a built kernel's configuration
- the loader entries in `system/boot/loader/entries/` are written by hand, one per installed kernel

### system

```sh
cp -rP --preserve=mode system/. /
USE=boot emerge --oneshot sys-apps/systemd-utils
bootctl install
locale-gen
env-update
useradd -m -s /bin/zsh -G wheel,audio,render,kvm,usb,seat,portage,plugdev,pipewire noah
ninitctl init
```

- the esp carries systemd-boot. `bootctl` is only needed once, the installed `sys-apps/systemd-utils` has `USE=-boot`
- `ninitctl init` compiles `/etc/ninit.d` into `/etc/ninit.d/depgraph`. services in `/etc/ninit.d/unused` stay disabled
- greetd starts tuigreet on vt 7, which launches sway through `dbus-run-session zsh -l -c sway`
- keyd turns caps lock into a control layer and `control-h` into backspace, from `/etc/keyd/default.conf`
- the firewall service loads `/etc/nftables.conf`, which drops everything inbound except ssh from the lan
- `/etc/udev/rules.d/webhid.rules` opens the hidraw nodes of the keyboards to the `plugdev` group
- `/etc/minidlna.conf` is configured but `net-misc/minidlna` has no service and is not in the world file
- `/etc/doas.conf` is not in the repo. write it before rebooting

### home

```sh
cp -rP --preserve=mode home/. ~/
git config --global user.name NAME
git config --global user.email EMAIL
git clone https://github.com/noahburchell/emacs ~/.config/emacs
```

- the emacs configuration lives in its own repository and is not duplicated here
- `~/.mozilla/firefox/PROFILE/user.js` belongs in the firefox profile directory, which exists after the first start of firefox
- sway starts `emacs --daemon` and `foot --server`, `mod+a` opens an emacsclient frame and `mod+return` a footclient window
- `/usr/local/bin/xdg-terminal-exec` runs footclient, `~/.config/xdg-terminals.list` still names the removed alacritty and is not consulted
- `~/.clang-format` reproduces the c style used across the projects, `~/.mg` configures the console editor that `EDITOR` points to
- `~/Scripts/bstatus` prints the charge of logitech hid++ devices, `~/.local/bin/media-to-exfat` moves a usb disk from btrfs to exfat through a staging copy

## not included

- the fonts in `~/.local/share/fonts`: Adwaita, Anthropic, Cascadia, IBM_VGA, iosevka and Liberation. sway, foot, fuzzel and firefox name Cascadia Mono NF and Iosevka, the IBM VGA font is from https://int10h.org/oldschool-pc-fonts/
- the macOS cursor theme in `~/.local/share/icons`
- `/usr/local`: whisper.cpp with the model `ggml-large-v3-turbo.bin` that the `transcribe` function in `.zextras` uses, parakeet, genpass, lavat and stockfish
- `~/.claude/headless.json` and `~/.claude/ask.md`, which the `ask` aliases in `.zextras` read
- the darktable state under `~/.config/darktable`
- keys, credentials, the git identity, the mail setup, lan host names and the script that mirrors keys between hosts

## verbatim files

- `gentoo/kernel/config-7.3.1-lychee`
- `gentoo/portage/savedconfig/sys-apps/busybox-1.36.1-r4`, where `# CONFIG_FOO is not set` lines are configuration
- `gentoo/portage/savedconfig/sys-firmware/ipxe-1.21.1_p20230601-r1`, where `#define` and `#undef` lines are configuration
- `system/etc/zsh/zshrc`, the grml zshrc
- `home/.mg`, `home/.config/gtk-3.0/bookmarks` and `home/.mozilla/firefox/PROFILE/user.js`, which carry no comments

the `#!` and `#%` lines in the ninit services are directives and are kept

## license

cc0 1.0, see `LICENSE`, with these exceptions:

- `system/etc/zsh/zshrc` is from grml-zsh-config, gpl v2
- `home/Scripts/bemoji` is bemoji 0.4.0 under its upstream license
