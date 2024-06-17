#!/bin/bash

# Description: This script counts the number of processes in a specified state
# and optionally displays the list of such processes

usage() {
    echo "Usage: $0 -s <process_state> [-c] [-l]"
    echo "  -s  Process state (mandatory)"
    echo "  -c  Count processes in the specified state"
    echo "  -l  List processes in the specified state"
    exit 1
}

# Initialize variables
count_flag=0
list_flag=0

# Parse options
while getopts "s:cl" opt; do
    case ${opt} in
        s )
            process_state=$OPTARG
            ;;
        c )
            count_flag=1
            ;;
        l )
            list_flag=1
            ;;
        * )
            usage
            ;;
    esac
done

# Check if process_state is set
if [ -z "$process_state" ]; then
    usage
fi

# Using ps to list processes with their PIDs and command names, filtering those in the specified state
process_list=$(ps -eo stat,pid,comm | awk -v state="$process_state" '$1 == state {print $2, $3}')

# Counting the number of such processes. Conditional expression needed, because if it's no
# processes found - it counts empty string as well
if [ -n "$process_list" ]; then
    process_count=$(echo "$process_list" | wc -l)
else
    process_count=0
fi

# Display the results
if [ "$count_flag" -eq 1 ] || [ "$count_flag" -eq 0 -a "$list_flag" -eq 0 ]; then
    echo "$process_count"
fi

if [ "$list_flag" -eq 1 ]; then
    if [ "$process_count" -gt 0 ]; then
        echo "$process_list"
    else
        echo "No processes found in state $process_state."
    fi
fi

