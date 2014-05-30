if [ -d /opt/buildroot-gcc342/bin ]; then
	export PATH=${PATH}:/opt/buildroot-gcc342/bin
fi
if [ -d /opt/sdcc/bin ]; then
	export PATH=${PATH}:/opt/sdcc/bin
fi
if [ -d "${HOME}/work/src" ]; then
	export PYTHONPATH=${HOME}/work/src
fi
li_env() {
	if [ -n "`uname|grep -i cygwin`" ]; then
		export PATH=/usr/local/bin:/usr/bin:${HOME}/bin
	fi
}
export CHUB_TEMP_IMG=/tftpboot/Image
export CHUB_FINAL_IMG=/tftpboot/Kernel.bin
chub_image() {
	if [ $# -lt 1 ]; then
		mipsel-unknown-linux-uclibc-objcopy -O binary -R .note -R .comment -S vmlinux "${CHUB_TEMP_IMG}" && /mnt/liricco/sftp_web/bin/lzma -9 -f -S .lzma "${CHUB_TEMP_IMG}" && mkimage -A mips -O linux -T kernel -C lzma -a 80000000 -e 0x8027c000 -n "Linux Kernel Image" -d "${CHUB_TEMP_IMG}.lzma" "${CHUB_FINAL_IMG}"
	else
		dtb-patch vmlinux "${1}" && mipsel-unknown-linux-uclibc-objcopy -O binary -R .note -R .comment -S vmlinux "${CHUB_TEMP_IMG}" && /mnt/liricco/sftp_web/bin/lzma -9 -f -S .lzma "${CHUB_TEMP_IMG}" && mkimage -A mips -O linux -T kernel -C lzma -a 80000000 -e 0x8027c000 -n "Linux Kernel Image" -d "${CHUB_TEMP_IMG}.lzma" "${CHUB_FINAL_IMG}"
	fi
}
alias ssh='ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
alias li_fs='ssh liriccoserver@fs-t110ii'
alias li_web='ssh liriccoweb@liricco.com'
