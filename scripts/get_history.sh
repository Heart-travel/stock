#!/bin/bash

source path.sh

# *********************************************************************
# Get all the history data of $1, include max_value, min_value, 
# open_value and close_value
# *********************************************************************

get_history_data(){
	cd ${DATA}
	mkdir ${1}
	cat /dev/null > ${1}/${1}_temp.txt
	cat /dev/null > ${1}/${1}_euc.txt
	cat /dev/null > ${1}/${1}_orig.txt
	cat /dev/null > ${DATA}/${1}/${1}_rush.txt
	cat /dev/null > ${DATA}/${1}/${1}_pic.txt
	cat /dev/null > ${DATA}/${1}/${1}_cal.txt
	curl http://quotes.money.163.com/service/chddata.html?code=$1 | tee ${1}/${1}_temp.txt
	tac ${1}/${1}_temp.txt | tee ${1}/${1}_euc.txt

	# Change the format of the data file from web
	iconv -f euc-cn -t utf-8 ${1}/${1}_euc.txt > ${1}/${1}_orig.txt

	# Delete the last line
	sed -i '$d' ${1}/${1}_orig.txt
	rm -f ${1}/${1}_euc.txt ${1}/${1}_temp.txt
}

main() {
	cd ${ROOT}
	for i in `cat $STOCK_FILE`
	do
		get_history_data $i
		for j in `cat ${i}/${i}_orig.txt`
		do
			cd ${SCRIPTS}
			bash ./_filter_rush.sh $i $j
		done
		cd ${SCRIPTS}
		./_probable.sh $i
	done
}

main
