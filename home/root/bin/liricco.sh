chub_devel() {
	mount --bind /dev /mnt/liricco/smb_chub-devel/dev && mount --bind /sys /mnt/liricco/smb_chub-devel/sys && mount --bind /proc /mnt/liricco/smb_chub-devel/proc && cp -L /etc/resolv.conf /mnt/liricco/smb_chub-devel/etc/ && chroot /mnt/liricco/smb_chub-devel /bin/bash
}
alias li_fs='ssh liriccoserver@fs-t110ii'
alias li_web='ssh liriccoweb@liricco.com'
