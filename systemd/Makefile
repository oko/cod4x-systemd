uninstall:
	-systemctl stop cod4x@main
	rm -f /etc/sysconfig/cod4x*
	rm -f /etc/systemd/system/cod4x@*service
	rm -f /usr/local/bin/cod4x.*
	systemctl daemon-reload
install: uninstall
	install -m 644 ./cod4x@.service /etc/systemd/system/
	install -m 755 ./cod4x.{pre,exec,post} /usr/local/bin/
	install -m 755 -d /var/lib/cod4x /etc/cod4x
	systemctl daemon-reload
test: install
	ln -sf /etc/systemd/system/cod4x@.service /etc/systemd/system/cod4x@main.service
	systemctl daemon-reload
	systemctl start cod4x@main
	systemctl status cod4x@main
	systemctl stop cod4x@main
	systemctl status cod4x@main
