#!/bin/bash

########################################################################
# Creates node groups as passed in a file
# Example input file: nodegroups_create.properties
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

# CREATE NODE GROUPS
if [ -n "$NODE_GROUP_LIST[@]" ]; then
	for l in $(seq 0 $((${#NODE_GROUP_LIST[@]} - 1)))
	do
		CURRENT_NODE_GROUP=`echo ${NODE_GROUP_LIST[$l]} | cut -d '=' -f1`
		CURRENT_NODE_GROUP_MEMBERS=( `echo ${NODE_GROUP_LIST[$l]} | cut -d '=' -f2` )
		
		# Create Node Groups
		for x in $(seq 0 $((${#CURRENT_NODE_GROUP_MEMBERS[@]} - 1)))
		do
			ctmnodegrp -EDIT -NODEGRP $CURRENT_NODE_GROUP -APPLTYPE OS -ADD "${CURRENT_NODE_GROUP_MEMBERS[x]}"
		done		
	done
fi
