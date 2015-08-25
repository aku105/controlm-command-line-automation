#!/bin/bash

########################################################################
# Deletes node groups passed in a file
# Example input file: nodegroups_delete.properties
########################################################################

if [ $# -ne 1 ]; then
	echo "Not enough parameters passed."
	echo "Usage: ./${dirname[0]} PATH_TO_PROPERTIES"
	exit 1
fi

PROP_PATH=$1

if ! [ -f "$PROP_PATH" ]; then
	echo "File $PROP_PATH doesn't exist. Exiting."
	exit 1
fi

NODE_GROUP_LIST=( `cat $PROP_PATH` )

# DELETE NODE GROUPS
if [ -n "${NODE_GROUP_LIST[@]}" ]; then
	for k in $(seq 0 $((${#NODE_GROUP_LIST[@]} - 1)))
	do
		CURRENT_NODE_GROUP="${NODE_GROUP_LIST[$k]}"
		
		# DELETE NODE GROUP
		ctmnodegrp -DELETE $CURRENT_NODE_GROUP >> deleteHold.log
	done
else
	echo "Passed file is empty, nothing to do."
fi
