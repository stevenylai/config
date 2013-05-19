if [ -d /opt/buildroot/bin ]; then
	export PATH=${PATH}:/opt/buildroot/bin
fi
if [ -d /opt/sdcc/bin ]; then
	export PATH=${PATH}:/opt/sdcc/bin
fi
li_env() {
	if [ -n "`uname|grep -i cygwin`" ]; then
		export PATH=/usr/local/bin:/usr/bin:${HOME}/bin
	fi
}
export CHUB_TEMP_IMG=/tftproot/Image
export CHUB_FINAL_IMG=/tftproot/Kernel.bin
chub_image() {
	mipsel-softfloat-linux-uclibc-objcopy -O binary -R .note -R .comment -S "${1}" "${CHUB_TEMP_IMG}" && rm -f "${CHUB_TEMP_IMG}.lzma" && lzma -9 -f -S .lzma "${CHUB_TEMP_IMG}" && mkimage -A mips -O linux -T kernel -C lzma -a 80000000 -e 0x8027c000 -n "Linux Kernel Image" -d "${CHUB_TEMP_IMG}.lzma" "${CHUB_FINAL_IMG}"
}
alias li_fs='ssh liriccoserver@fs-t110ii'
alias li_web='ssh liriccoweb@liricco.com'
