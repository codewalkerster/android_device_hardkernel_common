#!/vendor/bin/sh

PATH=/vendor/xbin/:/vendor/bin/:

# ensure any directories/files created are initially only
# u+rwx, g+rw, o+r
umask 0017

# crash file root dir
FILE_VENDOR_DIR="/data/vendor"
FILE_ROOT="$FILE_VENDOR_DIR/ramdump"

# fulldump file name
FULL_PREFIX="crashdump-"
FULL_INDEX=1
FULL_SUFFIX=".bin"
FULL_NAME=$FULL_PREFIX$FULL_INDEX$FULL_SUFFIX

# save fulldump if mdump node exists
MDUMP_SYSFS_NODE="/sys/kernel/mdump/compmsg"
FULLDUMP_LOG="fulldump-log.txt"
WAIT_CNT=0
MEMDUMP_OVERRIDE=1

#
# function
#
function check_dump_log_size() {
	DUMP_SIZE=`ls -l $FILE_ROOT/$FULLDUMP_LOG | awk '{print $5}'`
	if [ $DUMP_SIZE -gt 10000 ]; then
		echo "=========== Logsize > 10KB, cleanup ========" > $FILE_ROOT/$FULLDUMP_LOG
	else
		echo "============================================" >> $FILE_ROOT/$FULLDUMP_LOG
		ls -lh $FILE_ROOT >> $FILE_ROOT/$FULLDUMP_LOG
	fi
}

function check_vendor_is_mounted() {
	if [ ! -d $FILE_ROOT ]; then
		mkdir -p $FILE_ROOT
	fi

	check_dump_log_size

	WAIT_CNT=1
	while [ ! -d $FILE_VENDOR_DIR ]
	do
		sleep 1
		WAIT_CNT=$(($WAIT_CNT + 1))
		if [[ "$WAIT_CNT" -eq "15" ]]; then
			echo "### Error: userdata is not mounted!" >> $FILE_ROOT/$FULLDUMP_LOG
			exit 3
		fi
	done
}

function check_sysnode_is_exist() {
	echo "# check_sysnode_is_exist ?" >> $FILE_ROOT/$FULLDUMP_LOG
	WAIT_CNT=1
	while [ ! -e $MDUMP_SYSFS_NODE ]
	do
		sleep 1
		WAIT_CNT=$(($WAIT_CNT + 1))
		if [[ "$WAIT_CNT" -eq "30" ]]; then
			echo "# No found [$MDUMP_SYSFS_NODE], exit." >> $FILE_ROOT/$FULLDUMP_LOG
			exit 4
		fi
	done

	echo "# Found [$MDUMP_SYSFS_NODE], save it." >> $FILE_ROOT/$FULLDUMP_LOG
}

function clean_old_fulldump_bin() {
	if [ $MEMDUMP_OVERRIDE -eq 1 ]; then
		while [ -e $FILE_ROOT/$FULL_NAME ]
		do
			rm -rf $FILE_ROOT/$FULL_NAME
			echo "# RM old crash file [$FULL_NAME] ok." >> $FILE_ROOT/$FULLDUMP_LOG
			FULL_INDEX=$(($FULL_INDEX + 1))
			FULL_NAME=$FULL_PREFIX$FULL_INDEX$FULL_SUFFIX
		done
		FULL_INDEX=1
		FULL_NAME=$FULL_PREFIX$FULL_INDEX$FULL_SUFFIX
	else
		echo "# Add new memory dump file." >> $FILE_ROOT/$FULLDUMP_LOG
		while [ -e $FILE_ROOT/$FULL_NAME ]
		do
			FULL_INDEX=$(($FULL_INDEX + 1))
			FULL_NAME=$FULL_PREFIX$FULL_INDEX$FULL_SUFFIX
		done
		echo $FULL_NAME >> $FILE_ROOT/$FULLDUMP_LOG
	fi
}

function save_new_fulldump_bin() {
	echo "# Cat [$MDUMP_SYSFS_NODE] start..." >> $FILE_ROOT/$FULLDUMP_LOG
	cat $MDUMP_SYSFS_NODE > $FILE_ROOT/$FULL_NAME
	echo "# Cat [$MDUMP_SYSFS_NODE] finish." >> $FILE_ROOT/$FULLDUMP_LOG
	echo " " >> $FILE_ROOT/$FULLDUMP_LOG
	ls -lh $FILE_ROOT >> $FILE_ROOT/$FULLDUMP_LOG
	echo " " >> $FILE_ROOT/$FULLDUMP_LOG
	sync
	echo "# The device will reboot after 20 seconds ..." >> $FILE_ROOT/$FULLDUMP_LOG
	echo " " >> $FILE_ROOT/$FULLDUMP_LOG
	sleep 20
	/system/bin/reboot
	echo "# The device reboot failed." >> $FILE_ROOT/$FULLDUMP_LOG
}

#
# main
#
check_vendor_is_mounted

check_sysnode_is_exist

clean_old_fulldump_bin

save_new_fulldump_bin

exit 0
