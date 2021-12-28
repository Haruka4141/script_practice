#!bin/bash

# read -p "Enter IP: " ip
ip="192.168.22.53"

response=$(ipmitool -I lanplus -H $ip -U admin -P admin raw 0xa 0x40)


declare -a response_arr
# index=0       #bash array start from 0

while [ ! -z "$response" ]
do
    # index=$(($index+1))     
    # response_arr[$index]=$(echo $response | cut -d ' ' -f 1)
    response_arr+=($(echo $response | cut -d ' ' -f 1))
    # echo $response | cut -d ' ' -f 1
    response=${response:3}
done

# for i in ${response_arr[@]}     # array
# do
#     echo $i
# done

source function.sh

version ${response_arr[0]}
entries ${response_arr[1]} ${response_arr[2]}
free_space ${response_arr[3]} ${response_arr[4]}
percent_used $ip
most_recent_add_timestamp ${response_arr[5]} ${response_arr[6]} ${response_arr[7]} ${response_arr[8]}
most_recent_delete_timestamp ${response_arr[9]} ${response_arr[10]} ${response_arr[11]} ${response_arr[12]}
operation_support ${response_arr[13]}
alloc_info $ip

exit 0