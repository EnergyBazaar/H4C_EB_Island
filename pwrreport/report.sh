#!/bin/bash

# Simple script to accumulate power data from an URL once per second,
# acumulate it, and write the power integral for one 15-minute interval
# in watt-hours to a file.
# There is zero error control right now.

URL="http://192.168.1.11/report"
OUTPUT="report.csv"

INTERVAL_DIFF=900
PREVIOUS_TIME=0
CURRENT_TIME=0
CURRENT_POWER=0
CURRENT_INTERVAL=`date +%s`
CURRENT_INTERVAL=$[CURRENT_INTERVAL - CURRENT_INTERVAL % INTERVAL_DIFF]
NEXT_INTERVAL=$[CURRENT_INTERVAL + INTERVAL_DIFF]
POWER_INTEGRAL=0
TIMEDIFF=1

update_current_time() {
	CURRENT_TIME=`date +%s`
}

get_current_power() {
	PREVIOUS_TIME=$CURRENT_TIME;
	while true; do
		CURRENT_POWER=`curl -s "$URL" | jq .power`;
		CURRENT_POWER=`( echo -n $CURRENT_POWER && echo 000 ) | sed 's/^0\?\(.*\)\.\(...\).*/\1\2/'` # multiply power by 1000 to make it more interesting
		update_current_time;
		if [ $PREVIOUS_TIME -ne $CURRENT_TIME ]; then
			TIMEDIFF=$[CURRENT_TIME - PREVIOUS_TIME]
			break;
		fi;
	done;
	echo "Current power: $CURRENT_POWER" >&2;
}

if [ -z `which jq` ]; then
	echo "You need jq (apt-get install jq)" >&2
	exit 1
fi;

echo "Accumulating power data from $URL, outputting to $OUTPUT" >&2

update_current_time;
while true; do
	if [ $CURRENT_TIME -ge $NEXT_INTERVAL ]; then
		POWER_WH=$[POWER_INTEGRAL / 3600]
		echo "Accumulated power in this interval: $POWER_WH Wh" >&2;
		echo "$CURRENT_INTERVAL - $NEXT_INTERVAL,$POWER_WH" >> "$OUTPUT"
		CURRENT_INTERVAL=$NEXT_INTERVAL
		NEXT_INTERVAL=$[CURRENT_INTERVAL + INTERVAL_DIFF]
		POWER_INTEGRAL=0
	fi;
	get_current_power;
	POWER_INTEGRAL=$[POWER_INTEGRAL + CURRENT_POWER * TIMEDIFF]
done;
