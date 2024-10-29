#! /bin/bash

function show_help() {

	echo -e "\e[1;35m [usage] \e[0m"
	echo "    $0 -m [mode name] -p [path] -d [dir] -p -t"
	echo ""
	echo -e "\e[1;35m [option] \e[0m"
	echo "    -m : mode name, eg: t982_ar301,  "
	echo "    -p : Compile a single directory, Pay attention to emptying the historical compilation file to prevent the file from being recompiled"
	echo "         Pay attention to emptying the historical compilation file to prevent the file from being recompiled"
	echo "         You also need to ensure that the directory can be compiled successfully independently"
	echo "    -t : top level mode，could detect more errors."
	echo "    -d : detect path, only output errors in this path "
	echo "    -c : clean output, eg out "
	echo "    -h : show help"
	echo ""
	echo -e "\e[1;35m [example] \e[0m"
	echo "    1) Compile the whole android project and detect all "
	echo "    	$0 -m t982_ar301 "
	echo "    2) Compile the whole android project and detect vendor/amlogic/common/apps "
	echo "    	$0 -m t982_ar301  -d vendor/amlogic/common/apps"
	echo "    3) Compile the specified directory and scan all "
	echo "    	$0 -m t982_ar301 -p vendor/amlogic/common/apps/NativeImagePlayer"
	echo "    4) Compile the specified directory and scan the specified folder under the directory, Turn on the highest level scan at the same time"
	echo "    	$0 -m t982_ar301 -p vendor/amlogic/common/apps/NativeImagePlayer -d jni -t -c"
	echo ""
	exit 1
}


function read_configer() {
	if [ $# -lt 1 ]; then
		show_help
	fi

	while getopts m:M:p:P:d:D:tThHcC opt; do
			case ${opt} in
			m|M)
					MODE_NAME=${OPTARG}
					;;
			p|P)
					COMP_PATH=${OPTARG}
					;;
			t|T)
					TOP_LEVEL="1"
					;;
			c|C)
					CLEAN_OUTPUT="1"
					;;
			d|D)
					DETECT_PATH=${OPTARG}
					;;
			h|H)
					show_help
					;;
			*)
					show_help
					;;
			esac
	done
}

function coverity_detect() {

	cov_tool=/proj/coverity/cov-analysis-linux64-2023.3.2/bin
	cov_out=out/cov_out
	cov_html=out/cov_html
	export COV_HOST=$(hostname)
    export ALLOW_NINJA_ENV=1
	echo -e "Cov-debug: begin !"
	if [ ! -d ".repo" ];then
		echo -e "Cov-debug: Please go to the project root directory for execution" && exit
	fi

	if [ -z "${MODE_NAME}" ]; then
		echo -e "Cov-debug: Please enter project name,eg ohm_gtv" && exit
	fi
	
	if [ -n "$COMP_PATH" ]; then
	    [ ! -d "$COMP_PATH" ] && echo -e "Cov-debug: $COMP_PATH is not exist" && exit
	fi

	HOME_DIR=`pwd -P`
	
	if [ X${CLEAN_OUTPUT} == X"1" ]; then
		if [ -z "$COMP_PATH" ]; then
			echo -e "Cov-debug: comp path is null, mean analyze whole source， so del out"
			rm -rf out
	    else
			echo -e "Cov-debug: comp path is ${DETECT_PATH}, rmmove it's output file"
			cov_keyword=${COMP_PATH##*/}
			find out -name *${cov_keyword}* |xargs rm -rf
		fi	
	fi	

	if [ -z "${COMP_PATH}" ]; then
	    echo -e "Cov-debug: sub dir is null, build android project now !"
		source build/envsetup.sh && lunch ${MODE_NAME}-userdebug
		[ $? -ne 0 ] && echo -e "Cov-debug: set env or lunch failure, please check" && exit
		${cov_tool}/cov-build --dir  ${cov_out} build/soong/soong_ui.bash --make-mode  otapackage -j4
		[ $? -ne 0 ] && echo -e "Cov-debug: build project failure " && exit
		cov_strip=${HOME_DIR}
	else
	    echo -e "Cov-debug: sub dir is ${COMP_PATH}, build it now !"
		${cov_tool}/cov-build --dir  ${cov_out} ./device/hardkernel/common/scripts/cov_build-subdir.sh ${MODE_NAME}-userdebug ${COMP_PATH}
		[ $? -ne 0 ] && echo -e "Cov-debug: build dir(${COMP_PATH})  failure " && exit
		cov_strip=${COMP_PATH}
	fi

	if [ -z "$DETECT_PATH" ]; then
	    echo -e "Cov-debug: detect path is null, mean analyze whole source"
		if [ X${TOP_LEVEL} == X"1" ]; then
			echo -e "Cov-debug: level flag is set, mean analyze in high"
			if [ -z "$COMP_PATH" ]; then
				${cov_tool}/cov-analyze --dir ${cov_out} --strip-path ${HOME_DIR} --aggressiveness-level high --all
			else
				${cov_tool}/cov-analyze --dir ${cov_out} --strip-path ${HOME_DIR} --aggressiveness-level high --tu-pattern "file('/${COMP_PATH}/*')" --all
			fi
		else
			echo -e "Cov-debug: level flag is not set, mean analyze by default"
			if [ -z "$COMP_PATH" ]; then
				${cov_tool}/cov-analyze --dir ${cov_out} --strip-path ${HOME_DIR}  --all
			else
				${cov_tool}/cov-analyze --dir ${cov_out} --strip-path ${HOME_DIR} --tu-pattern "file('/${COMP_PATH}/*')" --all
			fi
		fi
	else
	    echo -e "Cov-debug: detect path is ${DETECT_PATH}, analyze it"
		if [ X${TOP_LEVEL} == X"1" ]; then
			echo -e "Cov-debug: level flag is set, mean analyze in high"
	        ${cov_tool}/cov-analyze --dir ${cov_out} --strip-path ${HOME_DIR}/${cov_strip} --aggressiveness-level high --tu-pattern "file('/${DETECT_PATH}/*')"  --all
		else
			echo -e "Cov-debug: level flag is not set, mean analyze by default"
	        ${cov_tool}/cov-analyze --dir ${cov_out} --strip-path ${HOME_DIR}/${cov_strip} --tu-pattern "file('/${DETECT_PATH}/*')" --all
		fi
	fi
	[ $? -ne 0 ] && echo -e "Cov-debug: analyze  project failure " && exit
	$cov_tool/cov-format-errors --dir  ${cov_out} --html-output ${cov_html} --filesort   -x
	[ $? -ne 0 ] && echo -e "Cov-debug: format  project failure " && exit
}

function detect_media()
{
	   echo -e "Cov-debug: detect_media !"
}

read_configer $@

coverity_detect && echo -e "Cov-debug: over !"

########################################################################################################################################################################
