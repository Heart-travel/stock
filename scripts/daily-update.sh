#!/bin/bash

ROOT=~/source/stock
DATA=${ROOT}/data
RESULT=${ROOT}/result
SCRIPTS=${ROOT}/scripts
STOCK_FILE=${ROOT}/source/stock.txt
COMMITFLAG=0
CURRENT_DATE=`date +%Y-%m-%d`

double_rush_in_7_days(){
	LAST_RUSH_DATE=`tail -1 ${DATA}/${1}/${1}_rush.txt | awk '{print $1}'`
	LAST_RUSH_DATE_LINE_NR=`grep -nr ${LAST_RUSH_DATE} ${DATA}/${1}/${1}_orig.txt | awk -F ":" '{print $1}'`

	CURRENT_RUSH_LINE_NR=`grep -nr ${CURRENT_DATE} ${DATA}/${1}/${1}_orig.txt | awk -F ":" '{print $1}'`
	if [ -n "${LAST_RUSH_DATE_LINE_NR}" -a -n "${CURRENT_RUSH_LINE_NR}" ]; then
		DIFF=`expr ${CURRENT_RUSH_LINE_NR} - ${LAST_RUSH_DATE_LINE_NR}`
		#echo ${DIFF}
		if [ "${DIFF}" -lt 7 ];then
			echo ${CURRENT_RUSH_LINE_NR} | tee -a ${DATA}/${1}/${1}_rush_in_7_days.txt
		fi
	fi
}

update_data_today(){
	while read line
	do
		cd ${DATA}
		DATE=`date +%Y%m%d`
		curl http://quotes.money.163.com/service/chddata.html?code=${line}\&start=${DATE}\&end=${DATE} | tee ${DATA}/${line}/${line}_d_temp.txt
		tac ${line}/${line}_d_temp.txt | tee ${line}/${line}_euc.txt
	
		# Change the format of the data file from web
		iconv -f euc-cn -t utf-8 ${line}/${line}_euc.txt > ${line}/${line}_daily.txt
	
		# Delete the last line
		sed -i '$d' ${line}/${line}_daily.txt
	
		TEMP=`cat ${line}/${line}_daily.txt`
		if [ -n "$TEMP" ]; then
			COMMITFLAG=1
			echo ${TEMP} | tee -a ${DATA}/${line}/${line}_orig.txt

			# check if rush is happend, if happend, record it.
			bash ${SCRIPTS}/_filter_rush.sh ${line} ${TEMP}
			if [ $? -eq 1 ]; then
				# Check the previous rush date, if it occured in 7 days,
				# then record this to the file rush_in_7_days.txt
				double_rush_in_7_days ${line}

				echo ${line} | tee -a ${RESULT}/rush.txt
			fi
		fi 
	
		#clean the useless files
		rm -f ${DATA}/${line}/${line}_euc.txt ${DATA}/${line}/${line}_d_temp.txt ${DATA}/${line}/${line}_daily.txt
	done < ${STOCK_FILE}
}

Commit(){
	cd ${ROOT}
	git add .
	git commit -m `date "+%Y%m%d"`
	git push origin master
}


cd ${ROOT}
:> ${RESULT}/rush.txt
echo "********************************" | tee -a ${RESULT}/rush.txt
echo "      Today Rush numbers" | tee -a ${RESULT}/rush.txt
echo "********************************" | tee -a ${RESULT}/rush.txt

update_data_today;
bash ${SCRIPTS}/get_rush_short_numbers.sh

if [ "$COMMITFLAG" -eq 1 ];then
		Commit;
fi


