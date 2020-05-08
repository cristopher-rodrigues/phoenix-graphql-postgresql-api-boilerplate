#!/bin/bash
TRY_CMD=$1
while :
do
	bash -c "${TRY_CMD}"
	if [[ $? = 0 ]]; then
		exit 0
	fi	
	echo "Failed..."
	sleep 2
done
