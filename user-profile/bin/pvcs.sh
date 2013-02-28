getpvcs ()
{
	if [ ${#} -lt 2 ]; then
		echo "Usage: getpvcs <project> <version_label>"
		return
	fi
	silence=""
	if [ ${#} -gt 2 -a "${3}" = "-s" ]; then
		silence="${3}"
	fi
	project=${1}
	version_label=${2}
	python3 "${HOME}/bin/PVCS.py" "get" -pr "${PVCS_PROJ_BASE}" -id "${PVCS_LOGIN}" -z "${project}" -cd "${PVCS_CO_DIR}" -v "${version_label}" ${silence}
}
deltapvcs ()
{
	if [ ${#} -lt 3 ]; then
		echo "Usage: deltapvcs <project> <version_label> <work_dir>"
		return
	fi
	silence=""
	if [ ${#} -gt 3 -a "${4}" = "-s" ]; then
		silence="${4}"
	fi
	project=${1}
	version_label=${2}
	work_dir=${3}
	python3 "${HOME}/bin/PVCS.py" "status" -pr "${PVCS_PROJ_BASE}" -id "${PVCS_LOGIN}" -z "${project}" -cd "${PVCS_CO_DIR}" -v "${version_label}" -wd "${work_dir}" ${silence}
}
verifypvcs ()
{
	if [ ${#} -lt 3 ]; then
		echo "Usage: verifypvcs <project> <version_label> <work_dir>"
		return
	fi
	silence=""
	if [ ${#} -gt 3 -a "${4}" = "-s" ]; then
		silence="${4}"
	fi
	project=${1}
	version_label=${2}
	work_dir=${3}
	python3 "${HOME}/bin/PVCS.py" "verify" -pr "${PVCS_PROJ_BASE}" -id "${PVCS_LOGIN}" -z "${project}" -cd "${PVCS_CO_DIR}" -v "${version_label}" -wd "${work_dir}" ${silence}
}
putpvcs ()
{
	if [ ${#} -lt 4 ]; then
		echo "Usage: putpvcs <project> <version_label> <work_dir> <new_version_label> "
		return
	fi
	silence=""
	if [ ${#} -gt 4 -a "${5}" = "-s" ]; then
		silence="${5}"
	fi
	project=${1}
	version_label=${2}
	work_dir=${3}
	new_version_label=${4}
	python3 "${HOME}/bin/PVCS.py" "put" -pr "${PVCS_PROJ_BASE}" -id "${PVCS_LOGIN}" -z "${project}" -cd "${PVCS_CO_DIR}" -v "${version_label}" -wd "${work_dir}"  -nv "${new_version_label}" ${silence}
}

