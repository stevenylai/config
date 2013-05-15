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
alias li_fs='ssh liriccoserver@fs-t110ii'
alias li_web='ssh liriccoweb@liricco.com'
