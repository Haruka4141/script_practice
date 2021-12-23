#!/usr/bin/bash     # the shell name (load .bashrc)
                    # BASH: Bourne Again SHell

echo "Hello World!"
# read -p "Please input your first name: " firstname
# read -p "Please input your last name: " lastname
# echo -e "\nYour full name is : $firstname $lastname"

# read -p "Please input your filename: " fileuser
#                   - if fileuser is unset, fileuser="filename"
#                  :- if fileuser is empty or unset, fileuser="filename"
filename=${fileuser:-"filename"}

date1=$(date --date='2 days ago' +%Y%m%d)
date=$(date +%Y%m%d)
echo $date
file1=$filename$date
# touch "$file1"      # create empty file

#calculate pi
# read -p "The scale number(10~10000): " checking
num=${checking:-"10"}
                        #      v pipeline command, only deal one previous command
time echo "scale=$num; 4*a(1)" | bc -lq     # time: print execute time
                                            # bc: calculate tool
                                           
read -p "Please input Y/N : " yn            # -p: provide input message
test $yn == "Y" -o $yn == "y" && echo "Yes"
test $yn == "N" -o $yn == "n" && echo "No"
# use \ to separate command into multiple rows
test $yn != "Y" -o $yn != "y" -o \
     $yn != "N" -o $yn != "n" && \
     echo "I don't know your choice!"

if [ "$yn" == "Y" ] || [ "$yn" == "y" ]; then
    echo "Yes"
elif [ "$yn" == "N" ] || [ "$yn" == "n" ]; then
    echo "No"
else
    echo "I don't know your choice is!"
fi

# fail... 
# [ "$yn" == "Y" || "$yn" == "y" ] && echo "Yes" && exit 0
# [ "$yn" == "N" || "$yn" == "n" ] && echo "No" && exit 0

#local variable
myname=howard
echo "current language is $LANG"
echo 'currnet language is $LANG'
# unset myname

# parameter & shifting
# echo "Total parameter is $#"
# echo "Whole parameter (\$@) is $@"    # "$1" "$2" "$3" "$4"
# echo "Whole parameter (\$*) is $*"    # "$1c$2$3$4", c is space
# shift
# echo "Whole parameter (\$@) is $@"
# shift 3
# echo "Whole parameter (\$@) is $@"

if [ "$1" == "hello" ]; then
    echo "Hello, how are you?"
elif [ "$1" == "" ]; then
    echo "You must input paras. ex. $0 someword"
fi

read -p "Enter 1 or 2: " var1
case $var1 in
1)
    echo "1"
    ;;
2)
    echo "2"
    ;;
*)
    echo "not 1 or 2"
    ;;
esac

#           v sequence
for i in $(seq 1 100)
do
    echo $i
done
exit 0