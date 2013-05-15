if [ -n "`uname|grep -i cygwin`" ]; then
    export LC_ALL=en_US
fi
if [ -f "${HOME}/bin/pvcs.sh" ] ; then
	export PVCS_LOGIN="aeeylai:aeeylai"
	export PVCS_PROJ_BASE="//mot/numotionsoftware"
	export PVCS_CO_DIR="/tmp"
	source "${HOME}/bin/pvcs.sh"
fi
if [ -f "${HOME}/bin/athk.sh" ] ; then
	if [ -e "/cygdrive/d/StevenLai/Apps/Internet/uploads" ] ; then
		export RELEASE_DIR="/cygdrive/d/StevenLai/Apps/Internet/uploads"
	else
		export RELEASE_DIR="/tmp"
	fi
	source "${HOME}/bin/athk.sh"
fi
if [ -f "${HOME}/bin/latex.sh" ] ; then
	source "${HOME}/bin/latex.sh"
fi
if [ -f "${HOME}/bin/svn.sh" ] ; then
	export SVN_EDITOR=gvim
	source "${HOME}/bin/svn.sh"
fi
if [ -f "${HOME}/bin/git.sh" ] ; then
	source "${HOME}/bin/git.sh"
fi
if [ -f "${HOME}/bin/liricco.sh" ] ; then
	source "${HOME}/bin/liricco.sh"
fi
if [ -f "${HOME}/bin/django.sh" ] ; then
	source "${HOME}/bin/django.sh"
fi
if [ -f "${HOME}/bin/docbook.sh" ] ; then
	source "${HOME}/bin/docbook.sh"
fi
if [ -f "${HOME}/bin/tinyos.sh" ] ; then
	export SENSOR_PLATFORM=micaz
	source "${HOME}/bin/tinyos.sh"
fi
have () {
	which $@ > /dev/null 2>&1
}
alias quotes="sed -e 's/^/\"/g' -e 's/$/\"/g'"
