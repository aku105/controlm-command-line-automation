#!/bin/bash

########################################################################
# Holds all jobs in a table from AJF (or control m EM)
# Running jobs are killed
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

# List orderId for all the jobs which are in particular table and which are not either deleted or held
JOB_LIST=( `ctmpsm -listajftab $TABLE_NAME| grep -v Deleted | tail -n +4 | grep -vi hold | awk '{print $1}'` )

echo -n "Holding jobs"
simple_progress_ind &
pid=$!
# Loop among all jobs found by above command
for i in $(seq 0 $((${#JOB_LIST[@]} - 1)))
do
	# Job's group, not used in this script
	JOB_GROUP=( `ctmpsm -LISTDETAILS ${JOB_LIST[$i]} | grep '^Group:' | sed -r 's/(.*): (.*)/\2/g'` )
	JOB_EXECUTING_STATUS=( `ctmpsm -LISTJOB EXECUTING | grep ${JOB_LIST[$i]}` )

	# Kill if the job is running.
	if [ -n "$JOB_EXECUTING_STATUS" ]; then
			ctmkilljob -ORDERID ${JOB_LIST[$i]} >> deleteHold.log
			# ctmkilljob doesn't kill instantly, so have to wait some time.
			sleep 10
	fi
	# Hold current job in list
	ctmpsm -UPDATEAJF ${JOB_LIST[$i]} HOLD >> deleteHold.log
done
echo "Jobs held"
stop_progress_ind $pid