#!/bin/bash
#GL script 3/27/2018
#Khertic co auther

#Prompt for username
	read -p "Enter the User JHED ID: " username

		if [ ${#username} -eq 0 ]; then
		    echo "Illegal number of parameters. Please enter JHED ID for user name.";
			exit 0
		fi

# Check to see if this is a user who should not have the linux environment changed. If it is exit.

	excluded_users_regex="^(clinsequser|bmyers21|khetric1)$"

		if [[ $username =~ $excluded_users_regex ]] ; then
		    echo 'user '$username' is excluded, exiting...'
		    exit 1
		fi

#Create the home and priv folder paths with username provided

	dir=/mnt/qadmin/users/$username
	priv=/mnt/qadmin/users/$username/priv

# CREATE A REGEX FOR DDL USERS. IF USERNAME IS DDL THEN SET THEM UP OTHERWISE SET THEM UP AS A NON-DDL USER.

	ddl_users_regex="^(skight1|ktindal2|msherid3|ywang117|khetric1-clinical|lfleet1|matalar1)$"

# CREATE A REGEX FOR CIDR GENETIC ANALYSTS GROUP

	cidr_genetic_analysts_regex="^(pzhang13|jzhang10|imcmull1|sserio1|kkindil1)$"

# function for setting up standard (CIDR) users

	SET_UP_NON_DDL_USERS ()
		{
			#Check for the users directory
				if [ -d "$dir" ]; then
				   echo The $dir  folder exists.
				   echo
				   #Check for the priv directory
					if [ -d "$priv" ]; then
					    echo The $priv folder exists.
					    echo
					    cp -Rv /mnt/qadmin/users/skel/.defaultbash_profile /mnt/qadmin/users/$username/priv/.bash_profile
					    echo
						rm -rvf /mnt/qadmin/users/$username/priv/.sge_request
						echo
					    ln -svf /mnt/users/skel/.sge_request /mnt/qadmin/users/$username/priv/.sge_request
					    echo
					    chmod -Rv 700 $priv
					    echo
				            chown -Rv win\\$username:win\\jhg_all $priv
					else
					    mkdir -v $priv
					    echo
					    echo No directory found $priv creating it
					    echo
					    cp -Rv /mnt/qadmin/users/skel/.defaultbash_profile /mnt/qadmin/users/$username/priv/.bash_profile
					    echo
						rm -rvf /mnt/qadmin/users/$username/priv/.sge_request
						echo
					    ln -svf /mnt/users/skel/.sge_request /mnt/qadmin/users/$username/priv/.sge_request
					    echo
					    chmod -Rv 700 $priv
					    echo
				            chown -Rv win\\$username:win\\jhg_all $priv
					fi
				else
				   echo No directory found $dir
				   echo
				   mkdir -v $dir
				   echo
				   mkdir -v $priv
				   echo
					cp -Rv /mnt/qadmin/users/skel/.defaultbash_profile /mnt/qadmin/users/$username/priv/.bash_profile
					echo
					rm -rvf /mnt/qadmin/users/$username/priv/.sge_request
					echo
					ln -svf /mnt/users/skel/.sge_request /mnt/qadmin/users/$username/priv/.sge_request
					echo
					chmod -Rv 700 $priv
					echo
					chown -Rv win\\$username:win\\jhg_all $dir
					echo
				        chown -Rv win\\$username:win\\jhg_all $priv
						echo
				   echo "Users folders created"
				fi
		}

# function for setting up DDL users

	SET_UP_DDL_USERS ()
		{
			#Check for the users directory
				if [ -d "$dir" ]; then
				   echo The $dir  folder exists.
				   #Check for the priv directory
					if [ -d "$priv" ]; then
					    echo The $priv folder exists.
					    echo
					    cp -Rv /mnt/qadmin/users/skel/.defaultbash_profile_ddl /mnt/qadmin/users/$username/priv/.bash_profile
					    echo
						cp -Rv /mnt/qadmin/users/skel/cidrseqsuite_ddl.props /mnt/qadmin/users/$username/priv/cidrseqsuite.props
					    echo
						rm -rvf /mnt/qadmin/users/$username/priv/.sge_request
						echo
						ln -svf /mnt/users/skel/.sge_request_ddl /mnt/qadmin/users/$username/priv/.sge_request
					    echo
					    chmod -Rv 700 $priv
					    echo
				            chown -Rv win\\$username:win\\jhg_all $priv
					else
					    mkdir -v $priv
					    echo No directory found $priv creating it
					    echo
					    cp -Rv /mnt/qadmin/users/skel/.defaultbash_profile_ddl /mnt/qadmin/users/$username/priv/.bash_profile
					    echo
					    cp -Rv /mnt/qadmin/users/skel/cidrseqsuite_ddl.props /mnt/qadmin/users/$username/priv/cidrseqsuite.props
					    echo
						rm -rvf /mnt/qadmin/users/$username/priv/.sge_request
						echo
					    ln -svf /mnt/users/skel/.sge_request_ddl /mnt/qadmin/users/$username/priv/.sge_request
					    echo
					    chmod -Rv 700 $priv
					    echo
				            chown -Rv win\\$username:win\\jhg_all $priv
							echo
					fi
				else
				   echo No directory found $dir
				   echo
				   mkdir -v $dir
				   echo
				   mkdir -v $priv
				   echo
					cp -Rv /mnt/qadmin/users/skel/.defaultbash_profile_ddl /mnt/qadmin/users/$username/priv/.bash_profile
					echo
					cp -Rv /mnt/qadmin/users/skel/cidrseqsuite_ddl.props /mnt/qadmin/users/$username/priv/cidrseqsuite.props
					echo
					rm -rvf /mnt/qadmin/users/$username/priv/.sge_request
					echo
					ln -svf /mnt/users/skel/.sge_request_ddl /mnt/qadmin/users/$username/priv/.sge_request
					echo
					chmod -Rv 700 $priv
					echo
					chown -Rv win\\$username:win\\jhg_all $dir
				        echo
				        chown -Rv win\\$username:win\\jhg_all $priv
				        echo
				   echo "Users folders created"
				fi
		}

# function for setting up DDL users

	SET_UP_CIDR_GENETIC_ANALYSTS ()
		{
			#Check for the users directory
				if [ -d "$dir" ]; then
				   echo The $dir  folder exists.
				   echo
				   #Check for the priv directory
					if [ -d "$priv" ]; then
					    echo The $priv folder exists.
					    echo
					    cp -Rv /mnt/qadmin/users/skel/.defaultbash_profile_ga /mnt/qadmin/users/$username/priv/.bash_profile
					    echo
						rm -rvf /mnt/qadmin/users/$username/priv/.sge_request
						echo
					    ln -svf /mnt/users/skel/.sge_request /mnt/qadmin/users/$username/priv/.sge_request
					    echo
					    chmod -R 700 $priv
					    echo
				            chown -R win\\$username:win\\jhg_all $priv
					else
					    mkdir -v $priv
					    echo
					    echo No directory found $priv creating it
					    echo
					    cp -Rv /mnt/qadmin/users/skel/.defaultbash_profile_ga /mnt/qadmin/users/$username/priv/.bash_profile
					    echo
						rm -rvf /mnt/qadmin/users/$username/priv/.sge_request
						echo
					    ln -svf /mnt/users/skel/.sge_request /mnt/qadmin/users/$username/priv/.sge_request
					    echo
					    chmod -Rv 700 $priv
					    echo
				            chown -Rv win\\$username:win\\jhg_all $priv
					fi
				else
				   echo No directory found $dir
				   echo
				   mkdir -v $dir
				   echo
				   mkdir -v $priv
				   echo
					cp -Rv /mnt/qadmin/users/skel/.defaultbash_profile_ga /mnt/qadmin/users/$username/priv/.bash_profile
					echo
					rm -rvf /mnt/qadmin/users/$username/priv/.sge_request
					echo
					ln -svf /mnt/users/skel/.sge_request /mnt/qadmin/users/$username/priv/.sge_request
					echo
					chmod -Rv 700 $priv
					echo
					chown -Rv win\\$username:win\\jhg_all $dir
					echo
				        chown -Rv win\\$username:win\\jhg_all $priv
						echo
				   echo "Users folders created"
				fi
		}


# if the input username is DDL, then set up that person using ddl specific files
# if the input username is CIDR genetic analyst, then set up that person using CIDR genetic analyst specific files
#  otherwise set them up as a standard user

	if [[ $username =~ $ddl_users_regex ]]
		then
			echo $username is a being set up as a DDL user
			SET_UP_DDL_USERS
		elif [[ $username =~ $cidr_genetic_analysts_regex ]]
			then
			echo $username is a being set up as a CIDR GENETIC ANALYST user
			SET_UP_CIDR_GENETIC_ANALYSTS
		else
			echo $username is a being set up as a non-DDL, assuming CIDR, user
			SET_UP_NON_DDL_USERS
	fi
