export SENSOR_PLATFORM=micaz
export COMPORTNO=`expr \`find /dev/ttyS* 2>&1|sort|head -n1|sed 's/^[^0-9]*//g'\` + 1`

PATH_BASIC="${PATH}:/opt/tinyos-1.x/tools/java/jni"
CLASSPATH_BASIC="${CLASSPATH}"
PYTHONPATH_BASIC="${PYTHONPATH}"

# Functions
tinyos_settings () {
    export TOSDIR="${TOSROOT}/tos"
    if [ -n "`uname|grep -i cygwin`" ]; then
    	export CLASSPATH="${CLASSPATH_BASIC};."
    else
    	export CLASSPATH="${CLASSPATH_BASIC}:."
    fi
    if [ -n "`uname|grep -i cygwin`" ]; then
	export PATH="`find /cygdrive/c/Program\ Files -maxdepth 3 -name 'jdk*' -type d 2>/dev/null|sort|tail -n1|sed -e 's/$/\/bin/g'`:${PATH_BASIC}"
    fi
    export PYTHONPATH="${PYTHONPATH_BASIC}"
}
t1 () {
    export TOSROOT="/opt/tinyos-1.x"
    export CONTRIB_DIR="/opt/tinyos-1.x/contrib/iTranSNet"
    tinyos_settings
    export PATH="/opt/msp430/bin:${PATH}:${TOSROOT}/tools/java/net/tinyos/sim:${TOSROOT}/tools/java/jni:${TOSROOT}/tools/scripts:${TOSROOT}/contrib/imote2/tools/bin"
    if [ -f "${TOSROOT}/tools/java/javapath" ]; then
	export CLASSPATH="`${TOSROOT}/tools/java/javapath`;${CLASSPATH}"
    fi
    if [ -n "`uname|grep -i cygwin`" ]; then
	export CLASSPATH="`cygpath -w ${CONTRIB_DIR}/tools/java`;`cygpath -w ${CONTRIB_DIR}/tos/lib/CommAck/java`;`cygpath -w  ${CONTRIB_DIR}/apps/PSWare`;${CLASSPATH}"
    else
	export CLASSPATH="${CONTRIB_DIR}/tools/java:${CONTRIB_DIR}/tos/lib/CommAck/java:${CONTRIB_DIR}/apps/PSWare:${CLASSPATH}"
    fi
    export MAKERULES="${TOSROOT}/tools/make/Makerules"
    alias smake="make mib510,/dev/ttyS`expr $COMPORTNO - 1`"
    alias motecom="export MOTECOM=serial@COM${COMPORTNO}:${SENSOR_PLATFORM}"
    alias unmotecom='unset MOTECOM'
    alias sf2="java net.tinyos.sf.SerialForwarder -comm tossim-serial@localhost 2>/dev/null"
    alias sf3="java net.tinyos.sf.SerialForwarder -comm tossim-radio@localhost 2>/dev/null"
    alias surge="java net.tinyos.surge.MainClass 0x7d"
    alias deluge="java net.tinyos.tools.Deluge"
    alias listen="java net.tinyos.tools.Listen"
    alias psware="java pubsub.edl2.receiver.notifier.DBNotifier"
}
t2 () {
    export TOSROOT="/opt/tinyos-2.x"
    tinyos_settings
    export PATH="/opt/jflashmm:${PATH}:${TOSROOT}-contrib/intelmote2/tools/platforms/intelmote2/bootloader"
    if [ -n "`uname|grep -i cygwin`" ]; then
	export CLASSPATH="`cygpath -w ${TOSROOT}/support/sdk/java/tinyos.jar`;${CLASSPATH}"
    else
	export CLASSPATH="${TOSROOT}/support/sdk/java/tinyos.jar:${CLASSPATH}"
    fi
    export PYTHONPATH=${PYTHONPATH}:${TOSROOT}/support/sdk/python/pyserial-2.5-rc2/build/lib
    export MAKERULES="${TOSROOT}/support/make/Makerules"
    export INTELMOTE2_CONTRIB_DIR=${TOSROOT}-contrib/intelmote2
    export TOSMAKE_PATH=$INTELMOTE2_CONTRIB_DIR/support/make
}


# SF (for T1)
sf () {
    baudrate=${SENSOR_PLATFORM}
    if [ $# -gt 0 ]; then
	baudrate=$1
    fi
    java net.tinyos.sf.SerialForwarder -comm serial@COM${COMPORTNO}:${baudrate}
}
sf1 () {
    baudrate=telosb
    COM=1
    if [ $# -gt 0 ]; then
        COM=$1
    fi
    java net.tinyos.sf.SerialForwarder -comm serial@COM${COM}:${baudrate}
}
