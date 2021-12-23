#!bin/bash

lunch[1]="hamberger"
lunch[2]="fried chicken"
lunch[3]="bento"
lunch[4]="buffet"
lunch[5]="instant noodle"
lunch[6]="ramen"
lunch[7]="sushi"
lunch[8]="katudou"
lunch[9]="gyuudou"
lunch_num=9

random=$(($RANDOM%$lunch_num+1))
echo "Eat ${lunch[$random]}!"
exit 0