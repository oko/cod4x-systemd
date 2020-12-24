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

7. Start your instance:

    ```
    $ sudo systemctl start cod4x@main
    $ sudo systemctl status cod4x@main
    $ ps aux | grep cod4x18 \
    root     3816737  0.0  0.0 231384  3776 ?        Ss   18:54   0:00 /bin/bash /usr/local/bin/cod4x.exec
    root     3816744  0.0  0.0  20640  9664 ?        S    18:54   0:00 systemd-nspawn -D /var/lib/cod4x/main/overlay-rootfs/mount --volatile=overlay --bind-ro=/var/lib/cod4x/main/overlay-game/mount:/cod4x --as-pid2 --pipe --drop-capability=all --user=nobody bash -c cd /cod4x ; exec ./cod4x18_dedrun +exec server.cfg
    nobody   3816751  0.8  0.1 704096 151496 ?       Ssl  18:54   0:09 ./cod4x18_dedrun +exec server.cfg
    jokamoto 3838122  0.0  0.0 221436   796 pts/3    S+   19:13   0:00 grep --color=auto cod4x
    ```

## Multi-Instance

This implementation uses `systemd` template units. To create another
server instance:

1. Create a new directory under `/etc/cod4x`, such as `searchonly` and
   set up `env` and `server.cfg` files. Then tweak for whatever game
   settings you need.
2. Start the server:

    ```
    $ sudo systemctl start cod4x@searchonly
    ```
