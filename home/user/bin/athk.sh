release()
{
	if [ ${#} -lt 1 ]; then
		echo "Usage: release <version> [platform]"
		return
	fi
	if [ ${#} -eq 2 ]; then
		platform="${2}/"
	else
		platform=""
	fi
	out=${RELEASE_DIR}
	in='.'
	proj=''
	GmpLib_BIN='DSLib.dll ASMIPMDll.dll GmpLib.dll GmpLib.lib'
	GmpLib_BASIC='gmp_error.h gmp_fun_ext.h gmp_macro.h gmp_struct.h'
	GmbLib_ADVANCED='gmp_eval.h gmp_infun_level1.h gmp_inmacro_level1.h gmp_instruct_level1.h'
	if [ -z "${proj}" ]; then
		for filename in ${GmpLib_BASIC} ${GmbLib_ADVANCED}
		do
			if [ -e "${in}/${filename}" ]; then
				proj="GmpLib"
			else
				proj=""
				break
			fi
		done
		if [ -n "${proj}" ]; then
			for filename in ${GmpLib_BIN}
			do
				if [ -e "${in}/Debug/${filename}" -a -e "${in}/Release/${filename}" ]; then
					proj="GmpLib"
				else
					proj=""
					break
				fi
			done
		fi
	fi

	GmpRTC_BIN='RTCLib/Debug/RTCLib.lib AuxLib/H AuxLib/SRC AuxLib/AuxLib.pjt AuxLib/Debug/AuxLib.lib GMPRTC/LIB GMPRTC/lnk_dsp.cmd GMPRTC/GMPRTC.pjt drivers'
	if [ -z "${proj}" ]; then
		for filename in ${GmpRTC_BIN}
		do
			if [ -e "${in}/${filename}" ]; then
				proj="GmpRTC"
			else
				proj=""
				break
			fi
		done
	fi

	SCFMAKER_BIN='Cfg_Mode.xls GlobalDefinition.xls HallSnrTypes.xls EncInterfaceTypes.xls ChannelApplication.xls GmpConfigureToolLibraryDb.sdf GmpConfigureToolLibraryDb_T.sdf CustomOpenFileDialog.dll DynamicDataDisplay.dll EncryptDecryptClass.dll Interop.Microsoft.Office.Core.dll Interop.VBIDE.dll PluginHandler.dll PluginInterface.dll SCFMaker.exe SCFMaker.exe.config SCFMaker.pdb SCFMaker.vshost.exe SCFMaker.vshost.exe.config Yogesh.ExcelXml.dll Yogesh.Extensions.dll ScfMakerErrorHandler.dll'
	SCFMaker_FILES='HWDB SWDB Images OCA'
	if [ -z "${proj}" ]; then
		for filename in ${SCFMAKER_BIN}
		do
			if [ -e "${in}/GmpConfigureTool/bin/${platform}Release/${filename}" ]; then
				proj="SCFMaker"
			else
				echo "Missing file for SCFMaker: ${filename}"
				proj=""
				break
			fi
		done
	fi

	if [ -n "${proj}" ]; then
		echo "Project found: ${proj}"
	else
		echo "Cannot determine project!"
	fi

	if [ "${proj}" = "GmpLib" ]; then
		GmpLib_Release_Basic="GmpLib-v${1}"
		GmpLib_Release_Internal="Internal GmpLib-v${1}"
		rm -Rf "${out}/${GmpLib_Release_Basic}"
		mkdir "${out}/${GmpLib_Release_Basic}"
		mkdir "${out}/${GmpLib_Release_Basic}/Debug"
		mkdir "${out}/${GmpLib_Release_Basic}/Release"
		for filename in ${GmpLib_BASIC}
		do
			cp --preserve=timestamps "${in}/${filename}" "${out}/${GmpLib_Release_Basic}"
		done
		for filename in ${GmpLib_BIN}
		do
			cp --preserve=timestamps "${in}/Debug/${filename}" "${out}/${GmpLib_Release_Basic}/Debug"
			cp --preserve=timestamps "${in}/Release/${filename}" "${out}/${GmpLib_Release_Basic}/Release"
		done
		rm -Rf "${out}/${GmpLib_Release_Internal}"
		mkdir "${out}/${GmpLib_Release_Internal}"
		for filename in ${GmbLib_ADVANCED}
		do
			cp --preserve=timestamps "${in}/${filename}" "${out}/${GmpLib_Release_Internal}"
		done
	elif [ "${proj}" = "GmpRTC" ]; then
		RTC_Release="Internal GmpRTC-v${1}"
		rm -Rf "${out}/${RTC_Release}"
		mkdir "${out}/${RTC_Release}" "${out}/${RTC_Release}/AuxLib" "${out}/${RTC_Release}/AuxLib/Debug" "${out}/${RTC_Release}/GMPRTC" "${out}/${RTC_Release}/RTCLib" "${out}/${RTC_Release}/RTCLib/Debug"
		for filename in ${GmpRTC_BIN}
		do
			cp --preserve=timestamps -R "${in}/${filename}" "${out}/${RTC_Release}/${filename}"
		done
		cp --preserve=timestamps -R "${in}/OCALib-Standard" "${out}/${RTC_Release}/OCALib"
		cp --preserve=timestamps -R "${in}/OUT2BINConverter" "${out}/${RTC_Release}/GMPRTC/Debug"
		sed "s/OCALib-Standard/OCALib/g" "${out}/${RTC_Release}/GMPRTC/GMPRTC.pjt" > "${out}/${RTC_Release}/GMPRTC/GMPRTC2.pjt"
		mv "${out}/${RTC_Release}/GMPRTC/GMPRTC2.pjt" "${out}/${RTC_Release}/GMPRTC/GMPRTC.pjt"
	elif [ "${proj}" = "SCFMaker" ]; then
		SFMaker_Release="SCFMaker ${1}"
		rm -Rf "${out}/${SFMaker_Release}"
		mkdir "${out}/${SFMaker_Release}"
		mkdir "${out}/${SFMaker_Release}/SCFMaker Plugins"
		for filename in ${SCFMAKER_BIN}
		do
			cp --preserve=timestamps "${in}/GmpConfigureTool/bin/${platform}Release/${filename}" "${out}/${SFMaker_Release}"
		done
		for filename in ${SCFMaker_FILES}
		do
			cp --preserve=timestamps -R "${in}/GmpConfigureTool/${filename}" "${out}/${SFMaker_Release}"
		done
	fi
	chmod -R a+rw "${out}"/*

	#find "${out}" -name '.svn'|sed -e 's/^/\"/g' -e 's/$/\"/g'|xargs rm -Rf
}
pass ()
{
	PYTHON3_EXE=/usr/bin/python3
	if [ ! -x "${PYTHON3_EXE}" ]; then
		return
	fi
	cp --preserve=timestamps "${HOME}/bin/xlsPass.py" /tmp
	#"${PYTHON3_EXE}" "`cygpath -w /tmp/xlsPass.py`" "$@"
	"${PYTHON3_EXE}" "/tmp/xlsPass.py" "$@"
	rm -f /tmp/xlsPass.py
}
rm_db ()
{
	PYTHON3_EXE=/usr/bin/python3
	if [ ! -x "${PYTHON3_EXE}" ]; then
		return
	fi
	"${PYTHON3_EXE}" "${HOME}/bin/gmp.py"
}
nuspace ()
{
	BUILD="Release"
	if [ ${#} -gt 0 ]; then
		BUILD="${1}"
	fi
	APP_FOLDER=`find . -name 'ApplicationFolder' -type d`
	if [ -z "${APP_FOLDER}" ]; then
		echo "ApplicationFolder not found!"
		return
	fi
	PREFIX="${APP_FOLDER}/Nuspace"
	DLL_LIST="ASMIPMDll.dll libamcoscomm.dll GmpLib.dll GmpLib.pdb DSLib.dll NuPsmLib.dll NuPSM_Config.xml"
	PROJ_LIST=( "HealthMonitor" "GmpTester" "NuDiagnostic" "DatalogServer" "GmpLib" "GmpLib" "GmpLib" "GmpLib" "PSM/PSM/bin" "NuSpace/ErrorLogViewer/bin" )
	TARGET_LIST=( "System Diagnose/Startup/HealthMonitor" "System Diagnose/NuDiagnostic" "System Diagnose/NuDiagnostic" "System Diagnose/Startup/DatalogServer" "System Diagnose/Startup/DatalogServer" "System Diagnose/PMS" "System Diagnose/Startup/PSM" "System Diagnose/Startup/MachineHealthMonitor" "System Diagnose/Startup/PSM" "Utilities/Error log viewer" )
	for index in 0 1 2 3 4 5 6 7 8
	do
		for dll_file in ${DLL_LIST}
		do
			if [ -e "${PROJ_LIST[index]}/${BUILD}/${dll_file}" -a -e "${PREFIX}/${TARGET_LIST[index]}" ]; then
				cp --preserve=timestamps -f "${PROJ_LIST[index]}/${BUILD}/${dll_file}" "${PREFIX}/${TARGET_LIST[index]}"
				chmod a+rx "${PREFIX}/${TARGET_LIST[index]}/${dll_file}"
			fi
		done
		if [ "`find \"${PROJ_LIST[index]}/${BUILD}\" -name '*.exe'|grep -v 'vshost'|wc -l`" -gt 0 ]; then
			exe_list="`find \"${PROJ_LIST[index]}/${BUILD}\" -name '*.exe'|grep -v 'vshost'`"
			for exe_file in ${exe_list}
			do
				chmod a+rx "${exe_file}"
				cp --preserve=timestamps -f "${exe_file}" "${PREFIX}/${TARGET_LIST[index]}"
			done
		fi
	done
	if [ -e "NuSpace/ErrorLogViewer/bin/${BUILD}/ErrorLog_Viewer.exe" ]; then
		cp --preserve=timestamps "NuSpace/ErrorLogViewer/bin/${BUILD}/ErrorLog_Viewer.exe" "${PREFIX}/Utilities/Error log viewer/Error log viewer.exe"
		chmod a+rx "${PREFIX}/Utilities/Error log viewer/Error log viewer.exe"
	fi
	APP_STORE=`find . -name 'AppStore' -type d`
	if [ -z "${APP_STORE}" ]; then
		echo "AppStore not found!"
		return
	fi
	if [ -e "${APP_STORE}/bin/${BUILD}/Nuspace.exe" ]; then
		cp --preserve=timestamps -f "${APP_STORE}/bin/${BUILD}/Nuspace.exe" "${APP_FOLDER}"
	fi
	if [ -e "${APP_STORE}/bin/${BUILD}/CustomWindow.dll" ]; then
		cp --preserve=timestamps -f "${APP_STORE}/bin/${BUILD}/CustomWindow.dll" "${APP_FOLDER}"
	fi
}
gmp_clean()
{
	find . -name '*.obj'|xargs rm
	find . -name '*.exp'|xargs rm
	find . -name '*.pch'|xargs rm
	find . -name '*.pdb'|xargs rm
	find . -name '*.res'|xargs rm
	find . -name '*.ilk'|xargs rm
	find . -name '*.idb'|xargs rm
	find . -name '*.ncb'|xargs rm
	find . -name '*.suo'|xargs rm
	find . -name 'BuildLog.htm'|xargs rm
}
