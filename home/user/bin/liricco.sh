if [ -d /opt/buildroot-gcc342/bin ]; then
	export PATH=${PATH}:/opt/buildroot/usr/bin
fi
if [ -d /opt/sdcc/bin ]; then
	export PATH=${PATH}:/opt/sdcc/bin
fi
li_env() {
	if [ -n "`uname|grep -i cygwin`" ]; then
		export PATH=/usr/local/bin:/usr/bin:${HOME}/bin:/opt/liricco/bin
	fi
}
chub_devel() {
	mount --bind /dev /mnt/liricco/smb_chub-devel/dev && mount --bind /sys /mnt/liricco/smb_chub-devel/sys && mount --bind /proc /mnt/liricco/smb_chub-devel/proc && cp -L /etc/resolv.conf /mnt/liricco/smb_chub-devel/etc/ && chroot /mnt/liricco/smb_chub-devel /bin/bash
}
alias li_fs='ssh liriccoserver@fs-t110ii'
alias li_web='ssh liriccoweb@liricco.com'
