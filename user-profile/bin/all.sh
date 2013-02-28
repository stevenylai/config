if [ -n "`uname|grep -i cygwin`" ]; then
    export LC_ALL=en_US
fi
if [ -f "${HOME}/bin/pvcs.bash" ] ; then
	export PVCS_LOGIN="aeeylai:aeeylai"
	export PVCS_PROJ_BASE="//mot/numotionsoftware"
	export PVCS_CO_DIR="/tmp"
	source "${HOME}/bin/pvcs.bash"
fi
if [ -f "${HOME}/bin/athk.bash" ] ; then
	if [ -e "/cygdrive/d/StevenLai/Apps/Internet/uploads" ] ; then
		export RELEASE_DIR="/cygdrive/d/StevenLai/Apps/Internet/uploads"
	else
		export RELEASE_DIR="/tmp"
	fi
	source "${HOME}/bin/athk.bash"
fi
if [ -f "${HOME}/bin/latex.bash" ] ; then
	source "${HOME}/bin/latex.bash"
fi
if [ -f "${HOME}/bin/svn.bash" ] ; then
	export SVN_EDITOR=gvim
	source "${HOME}/bin/svn.bash"
fi
if [ -f "${HOME}/bin/git.bash" ] ; then
	source "${HOME}/bin/git.bash"
fi
if [ -f "${HOME}/bin/liricco.bash" ] ; then
	source "${HOME}/bin/liricco.bash"
fi
if [ -f "${HOME}/bin/django.bash" ] ; then
	source "${HOME}/bin/django.bash"
fi
if [ -f "${HOME}/bin/tinyos.bash" ] ; then
	export SENSOR_PLATFORM=micaz
	source "${HOME}/bin/tinyos.bash"
fi
alias quotes="sed -e 's/^/\"/g' -e 's/$/\"/g'"
