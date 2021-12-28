#!bin/bash

# bash function cannot return value, must convert to echo
# function raw_command()
# {
#     response=$(ipmitool -I lanplus -H $1 -U admin -P admin raw $2 $3)

#     declare -a response_arr
#     index=0

#     while [ ! -z "$response" ]
#     do
#         index=$(($index+1))
#         response_arr[$index]=$(echo $response | cut -d ' ' -f 1)
#         # echo ${response_arr[$index]}
#         # echo $response | cut -d ' ' -f 1
#         response=${response:3}
#     done
# }

function version ()
{
    #echo $1
    case $1 in
    "51")
        ver="1.5 (v1.5, v2 compliant)"
        ;;
    *)
        ver="unknown"
    esac
    printf "%-15s : %s\n" "Version" "$ver"
}

function entries()
{
    LS=$((0x$1))
    MS=$((0x$2))
    MS=$(($MS<<8))
    ent=$(($LS+$MS))
    printf "%-15s : %s\n" "Entries" "$ent"
}

function free_space()
{
    LS=$((0x$1))
    MS=$((0x$2))
    MS=$(($MS<<8))
    space=$(($LS+$MS))
    printf "%-15s : %s bytes\n" "Free space" "$space"
}

function percent_used()
{
    response=$(ipmitool -I lanplus -H $1 -U admin -P admin raw 0xa 0x41)

    declare -a response_arr

    while [ ! -z "$response" ]
    do
        response_arr+=($(echo $response | cut -d ' ' -f 1))
        # echo $response | cut -d ' ' -f 1
        # echo $response
        response=${response:3}
    done

    LS=$((0x${response_arr[0]}))
    MS=$((0x${response_arr[1]}))
    MS=$(($MS<<8))
    possible_alloc_units=$(($LS+$MS))
    
    LS=$((0x${response_arr[2]}))
    MS=$((0x${response_arr[3]}))
    MS=$(($MS<<8))
    alloc_unit_size=$(($LS+$MS))

    LS=$((0x${response_arr[4]}))
    MS=$((0x${response_arr[5]}))
    MS=$(($MS<<8))
    free_alloc_units=$(($LS+$MS))

    # free_space_byte=$(($free_alloc_units*$alloc_unit_size))
    # total_space_byte=$(($possible_alloc_units*$alloc_unit_size))
    used_percent=$((echo "scale=3; 100-$free_alloc_units/$possible_alloc_units*100" | bc) | grep '[....]')
    printf "%-15s : %s %%\n" "Percent used" "$used_percent"
}

# LS byte first
function most_recent_add_timestamp()
{
    sec=$((0x$1))

    MS=$((0x$2))
    MS=$(($MS<<8))
    sec=$(($sec+$MS))
    shift 2
 
    MS=$((0x$1))
    MS=$(($MS<<16))
    sec=$(($sec+$MS))
    shift 1

    MS=$((0x$1))
    MS=$(($MS<<24))
    sec=$(($sec+$MS))

    add_time=$(date -u -d @${sec} +%Y/%m/%d\ %H:%M:%S)
    printf "%-15s : %s\n" "Last Add Time" "$add_time"
}

function most_recent_delete_timestamp()
{
    sec=$((0x$1))

    MS=$((0x$2))
    MS=$(($MS<<8))
    sec=$(($sec+$MS))
    shift 2
 
    MS=$((0x$1))
    MS=$(($MS<<16))
    sec=$(($sec+$MS))
    shift 1

    MS=$((0x$1))
    MS=$(($MS<<24))
    sec=$(($sec+$MS))

    #if [ $sec == "$((16#FFFFFFFF))" ]; then        # 0xFFFFFFFF is unspecified, 0x0~0x20000000 are relative to SEL device init.?
    if [ $sec == "0" ]; then                        # response return 0?
        printf "%-15s : %s\n" "Last Del Time" "Not Avaliable"
    else
        del_time=$(date -u -d @${sec} +%Y/%m/%d\ %H:%M:%S)
        printf "%-15s : %s\n" "Last Del Time" "$del_time"
    fi
}

function operation_support()
{
    #echo $((0x$1))
    if [ $((0x$1 >> 7 & 1)) == "1" ]; then
        printf "%-15s : %s %s\n" "Overflow" "true" "(Event have been dropped due to lack of space)"
    else
        printf "%-15s : %s\n" "Overflow" "false"
    fi

    declare -a support
    if [ $((0x$1 >> 3 & 1)) == "1" ]; then
        support+=("Delete")
    fi
    if [ $((0x$1 >> 2 & 1)) == "1" ]; then
        support+=("Partial Add")
    fi
    if [ $((0x$1 >> 1 & 1)) == "1" ]; then
        support+=("Reserve")
    fi
    if [ $((0x$1 & 1)) == "1" ]; then
        support+=("Get Alloc Info")
    fi

    printf "%-15s : " "Supported Cmds"
    for i in "${support[@]}"
    do
        printf "'$i' "      # printf "%s " $i is wrong
    done
    printf "\n"
}

function alloc_info()
{
    response=$(ipmitool -I lanplus -H $1 -U admin -P admin raw 0xa 0x41)

    declare -a response_arr
    while [ ! -z "$response" ]
    do
        response_arr+=($(echo $response | cut -d ' ' -f 1))
        response=${response:3}
    done

    LS=$((0x${response_arr[0]}))
    MS=$((0x${response_arr[1]}))
    MS=$(($MS<<8))
    possible_alloc_units=$(($LS+$MS))
    
    LS=$((0x${response_arr[2]}))
    MS=$((0x${response_arr[3]}))
    MS=$(($MS<<8))
    alloc_unit_size=$(($LS+$MS))

    LS=$((0x${response_arr[4]}))
    MS=$((0x${response_arr[5]}))
    MS=$(($MS<<8))
    free_alloc_units=$(($LS+$MS))

    LS=$((0x${response_arr[6]}))
    MS=$((0x${response_arr[7]}))
    MS=$(($MS<<8))
    largest_free_block_units=$(($LS+$MS))

    maximum_rec_size=$((0x${response_arr[8]}))
    
    printf "%0.1s" "-"{1..65}
    printf "\nAllocate Info:\n"
    printf "%-17s : %s\n" "# of Alloc Units" "$possible_alloc_units"
    printf "%-17s : %s\n" "Alloc Unit Size" "$alloc_unit_size"
    printf "%-17s : %s\n" "# of Free Units" "$free_alloc_units"
    printf "%-17s : %s\n" "Largest Free Bloc" "$largest_free_block_units"
    printf "%-17s : %s\n" "Maximum Rec Size" "$maximum_rec_size"
}

export -f version
export -f entries
export -f free_space
export -f most_recent_add_timestamp
export -f most_recent_delete_timestamp
export -f operation_support
export -f alloc_info
