chub_devel() {
	mount -t proc proc /mnt/liricco/smb_chub-devel/proc && mount --rbind /dev /mnt/liricco/smb_chub-devel/dev && mount --rbind /sys /mnt/liricco/smb_chub-devel/sys && cp -L /etc/resolv.conf /mnt/liricco/smb_chub-devel/etc/ && chroot /mnt/liricco/smb_chub-devel /bin/bash
}
alias li_fs='ssh liriccoserver@fs-t110ii'
alias li_web='ssh liriccoweb@liricco.com'
