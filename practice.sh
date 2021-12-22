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
time echo "scale=$num; 4*a(1)" | bc -lq     # time: print execute time
                                            # bc: calculate tool
# fail...                                            
# read -p "Please input Y/N : " yn
# [ "$yn" == "Y" || "$yn" == "y" ] && echo "Yes" && exit 0
# [ "$yn" == "N" || "$yn" == "n" ] && echo "No" && exit 0

# if [ "$yn" == "Y" ] || [ "$yn" == "y" ]; then
#     echo "Yes" && exit 0
# fi
# if [ "$yn" == "N" ] || [ "$yn" == "n" ]; then
#     echo "No" && exit 0
# fi
echo "I don't know your choice!" && exit 0

