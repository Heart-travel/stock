#!/bin/bash
ROOT=~/Sources/stock
DATA=${ROOT}/data
RESULT=${ROOT}/result
SCRIPTS=${ROOT}/scripts
STOCK_FILE=${ROOT}/source/stock.txt
PWD=`pwd`
CURRENT_DATE=`date +%Y%m%d`
RUSH_SHORT_LIST=${DATA}/rush_file_list.txt
RUSH_LATEST_FILE=${RESULT}/rush_latest_${CURRENT_DATE}.tx
