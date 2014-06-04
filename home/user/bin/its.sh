if [ -n "`uname|grep -i cygwin`" ]; then
	export CLASSAPTH="${CLASSPATH};`cygpath -w ${HOME}/work/src/its_demo/embedded/tools/java`"
else
	export CLASSAPTH="${CLASSPATH}:${HOME}/work/src/its_demo/embedded/tools/java"
fi
