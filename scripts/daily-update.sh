#!/bin/bash

ROOT=~/source/stock
DATA=${ROOT}/data
RESULT=${ROOT}/result
SCRIPTS=${ROOT}/scripts
STOCK_FILE=${ROOT}/source/stock.txt
COMMITFLAG=0

update_data_today(){
	while read line
	do
		cd ${DATA}
		DATE=`date +%Y%m%d`
		curl http://quotes.money.163.com/service/chddata.html?code=${line}\&start=${DATE}\&end=${DATE} | tee ${line}/${line}_d_temp.txt
		tac ${line}/${line}_d_temp.txt | tee ${line}/${line}_euc.txt
	
		# Change the format of the data file from web
		iconv -f euc-cn -t utf-8 ${line}/${line}_euc.txt > ${line}/${line}_daily.txt
	
		# Delete the last line
		sed -i '$d' ${line}/${line}_daily.txt
	
		TEMP=`cat ${line}/${line}_daily.txt`
		if [ -n "$TEMP" ]; then
			COMMITFLAG=1
			cat ${TEMP} | tee -a ${line}/${line}_orig.txt

			# check if rush is happend, if happend, record it.
			bash ${SCRIPTS}/_filter_rush.sh ${line} ${TEMP}
			if [ $? -eq 1 ]; then
				echo ${line} | tee -a ${RESULT}/rush.txt
			fi
		fi 
	
		#clean the useless files
		rm -f ${line}/${line}_euc.txt ${line}/${line}_d_temp.txt ${line}/${line}_daily.txt
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

if [ "$COMMITFLAG" -eq 1 ];then
		Commit;
fi


