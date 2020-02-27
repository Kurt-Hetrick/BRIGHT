#!/bin/bash

# every 7 days check how much available qumulo space is left. after 80% start sending out notifications

while sleep 7d ;
do

	# grab email addy

		SEND_TO=`cat /mnt/users/skel/SYSADMIN_SCRIPTS/EMAIL_ADDY_NEW_COMPLETED_PROJECTS.txt`

	# set variable for how filled up qumulo is

		FREE_QUMULO=$(df -h | grep "/mnt/research" | awk '{print $5}' | sed 's/%//g')

	if [[ $FREE_QUMULO -gt 80 && $FREE_QUMULO -lt 90 ]]
		then
			df -h \
				| grep "/mnt/research" \
				| awk '{print "currently",$4,"out of",$2,"left available.",$5,"full. Will check again in 7 days"}' \
			| mail -s "QUMULO MORE THAN 80% FULL" -r khetric1@jhmi.edu $SEND_TO
		elif [[ $FREE_QUMULO -gt 90 && $FREE_QUMULO -lt 95 ]]
			then
				df -h \
					| grep "/mnt/research" \
					| awk '{print "currently",$4,"out of",$2,"left available.",$5,"full. Will check again in 7 days"}' \
				| mail -s "QUMULO MORE THAN 90% FULL" -r khetric1@jhmi.edu $SEND_TO
		elif [[ $FREE_QUMULO -gt 95 ]]
			then
				df -h \
					| grep "/mnt/research" \
					| awk '{print "currently",$4,"out of",$2,"left available.",$5,"full. Will check again in 7 days"}' \
				| mail -s "QUMULO MORE THAN 95% FULL" -r khetric1@jhmi.edu $SEND_TO
		else
			:
	fi

done
