#!/bin/bash

########################################################################
# Deletes all jobs in a table from AJF (or control m EM)
# Only jobs in held state are deleted, so run script to hold jobs first.
########################################################################

if [ $# -ne 1 ]; then
	echo "Not enough parameters passed."
	echo "Usage: ./${dirname[0]} TABLE_NAME"
	exit 1
fi

TABLE_NAME=$1

# progress indicator
function simple_progress_ind {
  # Sleep at least 1 second otherwise this algorithm will consume
  # a lot system resources.
  interval=1
  echo -en "\n"
  while true
  do
    echo -ne "."
    sleep $interval
  done
}

# Stop progress indicator
function stop_progress_ind {
  exec 2>/dev/null
  kill $1
  echo -en "\n"
}

echo "Deleting all jobs"
simple_progress_ind &
pid=$!
# List order id of jobs which are not deleted and are in held state in passed table.
JOB_LIST=( `ctmpsm -listajftab $TABLE_NAME| grep -v Deleted | tail -n +4 | grep Hold | awk '{print $1}'` )

# Loop through all the jobs in above list and delete them
for i in $(seq 0 $((${#JOB_LIST[@]} - 1)))
do
		ctmpsm -UPDATEAJF ${JOB_LIST[$i]} DELETE >> deleteHold.log
done
echo "All jobs deleted"
stop_progress_ind $pid