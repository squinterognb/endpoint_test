#!/bin/bash
# --------------------------
# Lulobank - Cybersecurity
# Endpoint Tester
# Saul Quintero - 03/06/2020
# --------------------------

# help
if [ "$1" = "" ]; then
  echo "Usage: $0 <url>"
  exit 1
fi

# variables
ok_msg="200"
count_errors=0
count_try=1
break_flag=0

# trap ctrl-c
trap ctrl_c INT

function ctrl_c() {
    echo "** INTERRUPTED **"
    break_flag=1
}

while [ 1 ];
do
  result=$(curl -o /dev/null -s -w 'code=%{response_code} time=%{time_total}' $1)
  if [ $break_flag = 1 ]; then
    break
  fi
  echo "Try $count_try: Results $result"
  if [[ "$result" != *"code=$ok_msg"* ]]; then
    count_errors=$(($count_errors+1))
    echo "Error #$count_errors"
  fi
  count_try=$(($count_try+1))
done

echo "--------------------------------------------------"
echo "URL: $1"
echo "Total: $count_try"
let porc=$count_errors/$count_try*100
echo "Errors: $count_errors ($porc%)"
