if [ -n "`uname|grep -i cygwin`" ]; then
    CYGPATH="cygpath -w"
    SEP=";"
else
    CYGPATH="echo"
    SEP=":"
fi
export CLASSPATH="${CLASSPATH}${SEP}`${CYGPATH} ${HOME}/work/src/its_demo/embedded/tools/java`"
JARS="`find ${HOME}/work/src/its_demo/embedded/tools/java/third_party -name '*.jar'|xargs ${CYGPATH}|sed ':a;N;$!ba;s/\n/|/g'`"
if [ -n "`uname|grep -i cygwin`" ]; then
    JARS="`echo ${JARS}|sed 's/|/;/g'`"
else
    JARS="`echo ${JARS}|sed 's/|/:/g'`"
fi
export CLASSPATH="${CLASSPATH}${SEP}${JARS}"

