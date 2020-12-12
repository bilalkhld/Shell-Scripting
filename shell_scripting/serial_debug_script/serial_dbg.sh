#!/bin/sh

# Author : Bilal Khalid
# Script for serial port debugging
#

# Function to kill process
kill_PS () {
	echo "----------In Function kill_PS()----------"
	ps
	echo "kill_ps() - Killing Process $1"
	pid="$(ps | pgrep -x $1)"
	echo "kill_ps() - Process to kill is $pid"
	kill $pid
	echo "kill_ps() - return code: $?"
	echo "---------Exit Function kill_PS()---------"
}


# check for command line arguments
if [ $# -eq 0 ]
then
	echo "$0: Must Provide valid arguments"
	echo "$0: argument 1: AT Command"
	echo "$0: argument 2: Port Name"
	echo "$0: Example: $0 ATE0 ttyACM0"
	exit 1
fi

echo "$0: Available ACM ports are:"
ls -l /dev/ttyACM*
echo "$0: Available virtual USB ports are:"
ls -l /dev/ttyUSB*
# check if 2nd command line argument is missing

if [ -z $2 ]
then
	echo "$0: Please provide valid arguments"
	echo "$0: port name e.g. ttyACM0 or AT Command e.g. ATE0"
	exit 1
fi


# parse 1st command line argument
atCommand=$1
echo "$0: AT Command to send is: $atCommand"

# parse 2nd command line argument
atPort=/dev/$2
ls -l /dev/ | grep $2

if [ $? -ne 0 ]
then
	echo "$0: Port not found, see logs above for details"
	exit 1
fi

echo "$0: AT Channel Port is : $atPort"

# start process to listen file
echo "$0: Start reading file $atPort"
cat $atPort & 1>&2
echo "$0: return code: $?"
sleep 2

echo "$0: Sending Command to modem"
echo $atCommand
# Sending Command to file
echo -e $atCommand > $atPort
echo "$0: retun code: $?"
sleep 3

# kill this process before leaving
kill_PS cat

