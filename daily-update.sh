#!/bin/bash

while read line
do
	DATE=`date +%Y%m%d`
	curl http://quotes.money.163.com/service/chddata.html?code=${line}\&start=${DATE}\&end=${DATE} | tee ${line}/${line}_d_temp.txt
	tac ${line}/${line}_d_temp.txt | tee ${line}/${line}_euc.txt

	# Change the format of the data file from web
	iconv -f euc-cn -t utf-8 ${line}/${line}_euc.txt > ${line}/${line}_daily.txt

	# Delete the last line
	sed -i '$d' ${line}/${line}_daily.txt

	cat ${line}/${line}_daily.txt | tee -a ${line}/${line}_orig.txt

	#clean the usless files
	rm -f ${line}/${line}_euc.txt ${line}/${line}_d_temp.txt ${line}/${line}_daily.txt
done < stock.txt
