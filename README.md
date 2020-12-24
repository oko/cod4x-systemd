# `cod4x-systemd`: Call of Duty 4 X dedicated server under systemd

This is a set of build scripts and `systemd` service configuration for
[CoD4X](https://cod4x.me) dedicated servers. Quick summary:

* `mk_cod4x_squashfs`: build script for CoD4X game server binary/data
* `mk_fedora_rootfs`: build script for Fedora 33 rootfs
* `systemd/`: `systemd` unit file configuration to exec`cod4x18_dedrun`

This will run CoD4X in a `systemd-nspawn` jail, and has basic SELinux
compatibility via `context=` options on filesystem mounts.

## Usage

1. Download latest CoD4X Linux server binaries from the
   [CoD4X](https://cod4x.me) site
2. Copy your Windows game files to the server you're building on
3. Build the `cod4x.squashfs` filesystem with:
    
    ```
    $ sudo ./mk_cod4x_squashfs \
        ~/Downloads/cod4x_server-linux_19.2.zip \
	~/Downloads/cod4-game-files-dir \
	cod4x.squashfs
    ```

4. Build the `rootfs.squashfs` filesystem with:

    ```
    $ sudo ./mk_fedora_rootfs rootfs.squashfs
    ```

5. Install required files:

    ```
    $ sudo make install
    ```

6. Create your game server instance's env and config:

    ```
    $ sudo mkdir /etc/cod4x/main
    $ sudo cp systemd/cod4x.env.default /etc/cod4x/main/env
    $ sudo cp dedicated.cfg /etc/cod4x/main/server.cfg
    ```

    You can tweak the server config in `/etc/cod4x/main/server.cfg`.
