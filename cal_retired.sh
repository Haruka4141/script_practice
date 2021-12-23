#!bin/bash
# calculate demobilize date:
while [ true ]
do
    read -p "Demobilization Date (YYYYMMDD): " dem_date
# RE: Regular Expression
#                              [0-9]: search 0~9 continuous char
#                                   \{\}: count of continuous char, use \{ and \} to activate
    check=$(echo $dem_date | grep '[0-9]\{8\}')     # $() == `` prior to execute
    if [ "$check" == "" ]; then
        echo "wrong format!"
    else
        break
    fi
done

# -i: int         v --date=STRING: display by string
dem_date=$(date --date=$dem_date +%s)       # + Format
declare -i date=$(date +%s)
declare -i cal_date=$(($dem_date - $date))
declare -i cal_date_d=$(($cal_date/60/60/24))
declare -i cal_date_h=$(($cal_date/60/60%24))
declare -i cal_date_m=$(($cal_date/60%60))
declare -i cal_date_s=$(($cal_date%60))

if [ $cal_date -gt "0" ]; then
    echo "You will demobilize after ${cal_date_d}d:${cal_date_h}h:${cal_date_m}m:${cal_date_s}s"
else
    echo "You have been demobilized for $((-1*$cal_date_d))d"
fi
exit 0