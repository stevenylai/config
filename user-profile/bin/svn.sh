export SVN_EDITOR=vim
svn_rmnover () {
	if [ $# -eq 1 -a "${1}" = "all" ]; then
		svn status|grep '^\? \+'|sed -e 's/^\? \+/"/g' -e 's/$/"/g'|xargs rm -R
	else
		svn status|grep -v ApplicationFolder|grep '^\? \+'|sed -e 's/^\? \+/"/g' -e 's/$/"/g'|xargs rm -R
	fi
}
svn_lsdel () {
	if [ $# -lt 1 ]; then
		echo "Usage: svn_lsdel <svn path>"
		return
	fi
	svn ls -R "${1}"|sed -e 's/^/\"/g' -e 's/$/\"/g'|xargs -n1 "${HOME}"/bin/exist.sh
}
relocatesvn () {
	if [ $# -lt 2 ]; then
		echo "Usage: $0 <old path> <new path>"
		return
	fi
	dir='/cygdrive/c/Documents and Settings/Administrator/Desktop/Steven Lai/research/PaperWorks/Writing'
	if [ -d "$dir" ]; then
		cd "$dir"
		svn switch --relocate $1 $2
	fi
	dir='/opt/tinyos-1.x/contrib/iTranSNet'
	if [ -d "$dir" ]; then
		cd "$dir"
		svn switch --relocate $1 $2
	fi
	dir='/cygdrive/c/Program Files/Programming/Python31/Lib/site-packages/facebook/FBAuto'
	if [ -d "$dir" ]; then
		cd "$dir"
		svn switch --relocate ${1} ${2}
	fi
	dir='/cygdrive/c/Program Files/Internet/wsn'
	if [ -d "$dir" ]; then
		cd "$dir"
		svn switch --relocate ${1} ${2}
	fi
	cd
	svn switch --relocate ${1} ${2}
}
