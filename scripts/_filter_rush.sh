#!/bin/bash

ROOT=/home/CORPUSERS/xp019326/source/stock/auto-script
DATA=${ROOT}/data
RESULT=${ROOT}/result
SCRIPTS=${ROOT}/scripts
STOCK_FILE=${ROOT}/source/stock.txt

# *********************************************************************
# Check if $1 is a vilid number, such as 3, 18.5, 0.0
# *********************************************************************

is_number(){
	echo $1 | sed 's/\.\|-\|+\|%\|\^//g'  | grep [^0-9] >/dev/null && FLAG=0 || FLAG=1
	return $FLAG
}

# *********************************************************************
# 1. Get all the detail number of the history data of $1
# 2. Filter the day when the min_value equals the open_value, and store
# the data into the file ${1}_rush.txt
# *********************************************************************

get_and_store_value(){
	FLAG=0
	#:> ${DATA}/${1}/${1}_rush.txt

	DATE=inv_date;
	CODE=inv_code;
	NAME=inv_name;
	CLOSE=inv_close;
	MAX=inv_max;
	MIN=inv_min;
	OPEN=inv_open;
	DATE=`echo $2 | awk -F ',' '{print $1}'`
	SEC=`echo $2 | awk -F"[']" '{print $2}'`

	CODE=`echo $SEC | awk -F"[,]" '{print $1}'`
	NAME=`echo $SEC | awk -F"[,]" '{print $2}'`
	CLOSE=`echo $SEC | awk -F"[,]" '{print $3}'`
	MAX=`echo $SEC | awk -F"[,]" '{print $4}'`
	MIN=`echo $SEC | awk -F"[,]" '{print $5}'`
	OPEN=`echo $SEC | awk -F"[,]" '{print $6}'`

	#echo $DATE $CODE $CLOSE $MAX $MIN $OPEN
	if [ -n "$OPEN" -a -n "$MAX" -a -n "$MIN" -a -n "$CLOSE" ]; then
		VALID=0;
		is_number $CLOSE
		if [ $? -eq 1 ]; then
			VALID=`expr ${VALID} + 1`
		else
			VALID=`expr ${VALID} + 0`
		fi

		is_number $MAX
		if [ $? -eq 1 ]; then
			VALID=`expr ${VALID} + 1`
		else
			VALID=`expr ${VALID} + 0`
		fi
		
		is_number $MIN
		if [ $? -eq 1 ]; then
			VALID=`expr ${VALID} + 1`
		else
			VALID=`expr ${VALID} + 0`
		fi

		is_number $OPEN
		if [ $? -eq 1 ]; then
			VALID=`expr ${VALID} + 1`
		else
			VALID=`expr ${VALID} + 0`
		fi	

		if [ $VALID -eq 4 ]; then
			if [ $OPEN = $MIN -a $OPEN != 0.0 ]; then
				echo $DATE $CLOSE $MAX $MIN $OPEN | grep ^[0-5] | tee -a ${DATA}/$1/${1}_rush.txt
				FLAG=1
			fi

			echo $DATE $CLOSE | grep ^[0-5] | tee -a ${DATA}/${1}/${1}_pic.txt
		fi
	fi
	return ${FLAG}
}

get_and_store_value $1 $2
