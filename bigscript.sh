#!/bin/bash

# read from file line by line
input="script.sh"
lineNumber=1
while IFS= read -r line
do
	echo "$lineNumber"": $line"
	lineNumber=$(($lineNumber+1))
done < "$input"

# start daemon:
setsid

# process:
fork()

# get current date:
currentDate=`printf '%(%Y-%m-%d)T\n' -1`

# get date from zenity:
selectedDate=`zenity --calendar --date-format='%Y-%m-%d'`

# overwrite file:
 echo ... > file

# append to file
echo ... >> file


