#This script will grab all the user names in the /mnt/users directory, it will run a chmod and chown on each directory.
for dir in /mnt/qadmin/users/*
do
    if [ -d "$dir" ]
    then
        username=$(basename "$dir")
 	chmod -R 700  $dir/priv
        chown -R win\\$username:win\\jhg_all $dir/priv
    fi
done
