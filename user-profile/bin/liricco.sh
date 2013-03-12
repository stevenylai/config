if [ -d /opt/buildroot-gcc342/bin ]; then
	export PATH=${PATH}:/opt/buildroot-gcc342/bin
fi
if [ -d /opt/sdcc/bin ]; then
	export PATH=${PATH}:/opt/sdcc/bin
fi
li_env() {
	if [ -n "`uname|grep -i cygwin`" ]; then
		export PATH=/usr/local/bin:/usr/bin:${HOME}/bin:/opt/liricco/bin
	fi
}
alias li_fs='ssh liriccoserver@fs-t110ii'
alias li_web='ssh liriccoweb@liricco.com'
