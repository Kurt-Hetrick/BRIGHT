#!/bin/bash
#GL script 3/27/2018

#Prompt for username
read -p "Enter the User JHED ID: " username

if [ ${#username} -eq 0 ]; then
    echo "Illegal number of parameters. Please enter JHED ID for user name.";
    	exit 0
fi

excluded_users_regex="^(clinsequser|bmyers21|khetric1)$"

if [[ $username =~ $excluded_users_regex ]] ; then
    echo 'user '$username' is excluded, exiting...'
    exit 1
fi

#Create the home and priv folder paths with username provided
dir=/mnt/qadmin/users/$username
priv=/mnt/qadmin/users/$username/priv
ssh=/mnt/qadmin/users/$username/priv/.ssh

#Check for the users directory
if [ -d "$dir" ]; then
   echo The $dir  folder exists.
   #Check for the priv directory
	if [ -d "$priv" ]; then
	    echo The $priv folder exists.
	    cp -R /mnt/qadmin/users/skel/.defaultbashrc /mnt/qadmin/users/$username/priv/.bash_profile
	    ln -s /mnt/users/skel/.sge_request /mnt/qadmin/users/$username/priv/.sge_request
	    echo Bashrc copied to priv
	    chown -R win\\$username:nfsnobody $priv
	     #Create .ssh folder
			mkdir $ssh
			chmod -R 700 $ssh
			chown -R win\\$username:nfsnobody $ssh
	else
	    mkdir $priv
		mkdir $ssh
	    echo No directory found $priv creating it
	    cp -R /mnt/qadmin/users/skel/.defaultbashrc /mnt/qadmin/users/$username/priv/.bash_profile
	    ln -s /mnt/users/skel/.sge_request /mnt/qadmin/users/$username/priv/.sge_request
	    chown -R win\\$username:nfsnobody $priv
		chown -R win\\$username:nfsnobody $ssh
		chmod -R 700 $ssh
	    echo Bashrc copied to priv
	fi
else
   echo No directory found $dir
   mkdir $dir
   mkdir $priv
   mkdir $ssh
	cp -R /mnt/qadmin/users/skel/.defaultbashrc /mnt/qadmin/users/$username/priv/.bash_profile
	ln -s /mnt/users/skel/.sge_request /mnt/qadmin/users/$username/priv/.sge_request
 	echo Bashrc copied to priv
	chmod -R 700 $priv
	chown -R win\\$username:win\\jhg_all $dir
    chown -R win\\$username:nfsnobody $priv
	chown -R win\\$username:nfsnobody $ssh
	chmod -R 700 $ssh

   echo "Users folders created"
fi
