#!/bin/bash

STOCK_FILE=./stock.txt
PWD=`pwd`

# *********************************************************************
# Get all the history data of $1, include max_value, min_value, 
# open_value and close_value
# *********************************************************************

get_history_data(){
	mkdir $1
	curl http://quotes.money.163.com/service/chddata.html?code=$1 | tee $1/${1}_temp.txt
	tac $1/${1}_temp.txt | tee $1/${1}_euc.txt

	# Change the format of the data file from web
	iconv -f euc-cn -t utf-8 $1/${1}_euc.txt > $1/${1}_orig.txt

	# Delete the last line
	sed -i '$d' $1/${1}_orig.txt
	rm -f $1/${1}_euc.txt $1/${1}_temp.txt
}


# *********************************************************************
# Check if $1 is a vilid number, such as 3, 18.5, 0.0
# *********************************************************************

#is_number(){
#	echo $1 | sed 's/\.\|-\|+\|%\|\^//g'  | grep [^0-9] >/dev/null && FLAG=0 || FLAG=1
#	return $FLAG
#}

# *********************************************************************
# 1. Get all the detail number of the history data of $1
# 2. Filter the day when the min_value equals the open_value, and store
# the data into the file $1_filter.txt
# *********************************************************************

#get_and_store_value(){
#	:> $1/$1_filter.txt
#
#	for i in `cat $1/${1}_orig.txt`
#	do
#		DATE=inv_date;
#		CODE=inv_code;
#		NAME=inv_name;
#		CLOSE=inv_close;
#		MAX=inv_max;
#		MIN=inv_min;
#		OPEN=inv_open;
#		DATE=`echo $i | awk -F ',' '{print $1}'`
#		SEC=`echo $i | awk -F"[']" '{print $2}'`
#
#		CODE=`echo $SEC | awk -F"[,]" '{print $1}'`
#		NAME=`echo $SEC | awk -F"[,]" '{print $2}'`
#		CLOSE=`echo $SEC | awk -F"[,]" '{print $3}'`
#		MAX=`echo $SEC | awk -F"[,]" '{print $4}'`
#		MIN=`echo $SEC | awk -F"[,]" '{print $5}'`
#		OPEN=`echo $SEC | awk -F"[,]" '{print $6}'`
#
#		#echo $DATE $CODE $CLOSE $MAX $MIN $OPEN
#		if [ -n "$OPEN" -a -n "$MAX" -a -n "$MIN" -a -n "$CLOSE" ]; then
#			VALID=0;
#			is_number $CLOSE
#			if [ $? -eq 1 ]; then
#				VALID=`expr ${VALID} + 1`
#			else
#				VALID=`expr ${VALID} + 0`
#			fi
#
#			is_number $MAX
#			if [ $? -eq 1 ]; then
#				VALID=`expr ${VALID} + 1`
#			else
#				VALID=`expr ${VALID} + 0`
#			fi
#			
#			is_number $MIN
#			if [ $? -eq 1 ]; then
#				VALID=`expr ${VALID} + 1`
#			else
#				VALID=`expr ${VALID} + 0`
#			fi
#
#			is_number $OPEN
#			if [ $? -eq 1 ]; then
#				VALID=`expr ${VALID} + 1`
#			else
#				VALID=`expr ${VALID} + 0`
#			fi	
#
#			if [ $VALID -eq 4 ]; then
#				if [ $OPEN = $MIN -a $OPEN != 0.0 ]; then
#					echo $DATE $CLOSE $MAX $MIN $OPEN | grep ^[0-5] | tee -a $1/${1}_filter.txt
#				fi
#			fi
#		fi
#	done
#}

main() {
	for i in `cat $STOCK_FILE`
	do
		get_history_data $i
		for j in `cat $i/${i}_orig.txt`
		do
			cd $PWD
			./filter_min_open.sh $i $j
		done
		cd $PWD
		./probable.sh $i
	done
}

main
