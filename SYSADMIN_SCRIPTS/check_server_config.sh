#!/bin/env bash

user=$1

	if [[ ! $user ]]
		then
		user=$(whoami)
	fi

for server in $(qconf -sep | egrep "cidr" | awk '{split($1,foo,"."); print foo[1]}'); \
	do (ssh $user@$server uname -nr ; ssh $user@$server cat /etc/redhat-release; ssh $user@$server df -h /tmp | grep -v ^File) | paste - - - | grep -v Warning;
done
