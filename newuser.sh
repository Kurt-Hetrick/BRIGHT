#!/bin/bash
#GL script 3/27/2018

#Prompt for username
read -p "Enter the User JHED ID: " username

if [ ${#username} -eq 0 ]; then
    echo "Illegal number of parameters. Please enter JHED ID for user name.";
    	exit 0
fi


#Create the home and priv folder paths with username provided
dir=/mnt/qadmin/users/$username
priv=/mnt/qadmin/users/$username/priv

#Check for the users directory
if [ -d "$dir" ]; then
   echo The $dir  folder exists.
   #Check for the priv directory
	if [ -d "$priv" ]; then
	    echo The $priv folder exists.
	    cp -R /mnt/qadmin/users/skel/.defaultbashrc /mnt/qadmin/users/$username/priv/.bash_profile
	    cp -R /mnt/qadmin/users/skel/.sge_request/qadmin/users/$username/priv/.sge_request
	    echo Bashrc copied to priv
	    chmod -R 700 $priv
            chown -R win\\$username:win\\jhg_all $priv
	else
	    mkdir $priv
	    echo No directory found $priv creating it
	    cp -R /mnt/qadmin/users/skel/.defaultbashrc /mnt/qadmin/users/$username/priv/.bash_profile
	    cp -R /mnt/qadmin/users/skel/.sge_request/qadmin/users/$username/priv/.sge_request
	    chmod -R 700 $priv
            chown -R win\\$username:win\\jhg_all $priv
	    echo Bashrc copied to priv
	fi
else
   echo No directory found $dir
   mkdir $dir
   mkdir $priv
	cp -R /mnt/qadmin/users/skel/.defaultbashrc /mnt/qadmin/users/$username/priv/.bash_profile
	cp -R /mnt/qadmin/users/skel/.sge_request/qadmin/users/$username/priv/.sge_request
 	echo Bashrc copied to priv
	chmod -R 700 $priv
	chown -R win\\$username:win\\jhg_all $dir
        chown -R win\\$username:win\\jhg_all $priv

   echo "Users folders created"
fi
