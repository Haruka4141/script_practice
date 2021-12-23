#!bin/bash

while [ true ]
do
    read -p "Please enter directory: " dir
                            # v    v recommend to add " "
    if [ "$dir" == "" -o ! -d "$dir" ]; then
        echo "directory not exist!"
    else
        break
    fi
done

file_list=$(ls $dir)
for file in $file_list
do
    auth=""
    test -r "$dir/$file" && auth="$auth readable,"
    test -w "$dir/$file" && auth="$auth writable,"
    test -x "$dir/$file" && auth="$auth executable"
    echo "$dir/$file is$auth"
done
exit 0