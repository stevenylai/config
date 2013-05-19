if [ -n "`uname|grep -i cygwin`" ]; then
    export LC_ALL=en_US
fi
if [ -f "${HOME}/bin/liricco.sh" ] ; then
	source "${HOME}/bin/liricco.sh"
fi
have () {
	which $@ > /dev/null 2>&1
}
alias quotes="sed -e 's/^/\"/g' -e 's/$/\"/g'"
