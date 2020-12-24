rootfs:
	mk_fedora_rootfs rootfs.squashfs
install-systemd:
	$(MAKE) -C systemd install
install-rootfs:
	install -m 644 rootfs.squashfs /var/lib/cod4x/squashfs/rootfs.squashfs
install-cod4x:
	install -m 644 cod4x.squashfs /var/lib/cod4x/squashfs/cod4x.squashfs
install: install-systemd install-rootfs install-cod4x
