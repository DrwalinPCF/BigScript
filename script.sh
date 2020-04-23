#!/bin/bash
# Author           : Marek Zalewski ( s180465@student.pg.edu.pl )
# Created On       : 23/04/2020
# Last Modified By : Marek Zalewski
# Last Modified On : 23/04/2020
# Version          : 1.0.0
#
# Description      :
# Duyży skrypt z systemów operacyjnych: task scheduler
#
# Licensed under GPL (see /usr/share/common-licenses/GPL for more details
# or contact # the Free Software Foundation for a copy)

FILE_NAME=""
DIRECTORY=""

FILE_TYPE=""

SIZE=""
SIZE_MODE=""

FILE_ACCESS=""

FILE_CONTENT=""

clear_data() {
	FILE_NAME=""
	DIRECTORY=""

	FILE_TYPE=""

	SIZE=""
	SIZE_MODE=""

	FILE_ACCESS=""

	FILE_CONTENT=""
}

find_result() {
	local ARGS=""
	
	if [[ $DIRECTORY ]]; then
		ARGS="'${DIRECTORY}'"
	else
		ARGS="."
	fi
	
	if [[ $FILE_NAME ]]; then
		ARGS="${ARGS} -name '${FILE_NAME}'"
	fi
	
	if [[ $FILE_TYPE ]]; then
		ARGS="${ARGS} -type '${FILE_TYPE}'"
	fi
	
	if [[ $SIZE ]]; then
		ARGS="${ARGS} -size ${SIZE_MODE}${SIZE}c"
	fi
	
	if [[ $FILE_ACCESS ]]; then
		ARGS="${ARGS} ${FILE_ACCESS}"
	fi
	
	if [[ $FILE_CONTENT ]]; then
		ARGS="${ARGS} -exec grep -H '${FILE_CONTENT}' {} \;"
	fi
	
	local command="find ${ARGS} 2>/dev/null | cut -d ':' -f 1 | sort -u | zenity --text-info --title 'Znalezione pliki'"
	`eval ${command}`
}

print_data() {
	local menu=("1" "Nazwa pliku" "'$FILE_NAME'"   "2" "Katalog" "'$DIRECTORY'"   "3" "Typ pliku" "'$FILE_TYPE'"   "4" "Rozmiar pliku" "'$SIZE'"   "5" "Dostep do pliku" "'$FILE_ACCESS'"   "6" "Zawartosc pliku" "'$FILE_CONTENT'"   "7" "Szukaj" ""    "8" "Wyjscie" ""     "9" "Wyczysc" "")
	result=`zenity --list --height 350 --title 'Menu glowne' --column=Hidden --column=Menu "${menu[@]}" --column=Value --hide-column=1`
	exitcode=$?
	if [[ $exitcode == '0' && $result == "" ]]; then
		echo "7"
	elif [[ $exitcode == '0' ]]; then
		echo $result
	else
		echo ""
	fi
}

read_string() {
	local result=`zenity --entry --title $1 --text $2`
	echo $result
}

read_option() {
	case $1 in
		1)
			FILE_NAME=$(read_string "Nazwa pliku" "Podaj poszukiwana nazwe pliku")
			;;
		2)
			DIRECTORY=`zenity --file-selection --title "Przeszukiwany katalog" --directory`
		   ;;
		3)
			local menu=("b" "block (buffered) special"  "c" "character (unbuffered) special"  "d" "directory"  "p" "named pipe"  "f" "regular file"  "l" "symbolic link"  "s" "socket")
			FILE_TYPE=`zenity --list --multiple --title 'Typy plikow' --column=Hidden --column=Typy "${menu[@]}" --hide-column=1`
			FILE_TYPE="${FILE_TYPE//\|/\,}"
		   ;;
		4)
		   	while [[ 0 ]]; do
				SIZE=`zenity --entry --title 'Rozmiar' --text 'Podaj poszukiwany rozmiar pliku w bajtach'`
				if [[ $SIZE == "" ]]; then
					break;
				elif [[ ${SIZE//[0-9]*/} != "" ]]; then
					`zenity --error --text 'Podaj rozmiar samymi cyframi'`
				else
					break
				fi
			done
			
			if [[ $SIZE != "" ]]; then
				local menu=("=" "Dokladny rozmiar pliku"  "-" "Plik ma byc mniejszy od podanego rozmiaru"  "+" "Plik ma byc wiekszy od podanego rozmiaru")
				SIZE_MODE=`zenity --list --title 'Sposob porownania rozmiaru pliku' --column=Hidden --column=Porownanie "${menu[@]}" --hide-column=1`
				if [[ $SIZE_MODE == "" ]]; then
					SIZE=""
				elif [[ $SIZE_MODE == "=" ]]; then
					SIZE_MODE=""
				fi
			fi
		   ;;
		5)
			local menu=("writable" "Dostep do zapisu do pliku"  "readable" "Dostep do odczytu z pliku"  "executable" "Dostep do uruchomienia pliku")
			FILE_ACCESS=`zenity --list --multiple --title 'Dostep do plikow' --column=Hidden --column=Dostep "${menu[@]}" --hide-column=1`
			FILE_ACCESS="-${FILE_ACCESS//\|/ \-}"
		   ;;
		6) 
			FILE_CONTENT=$(read_string "Zawartosc pliku" "Pattern")
		   ;;
	esac
}

main() {
	INDEX=""
	while [[ 0 ]]; do
		INDEX=$(print_data)
		if [[ $INDEX -ge 1 && $INDEX -le 6 ]]; then
			read_option $INDEX
		elif [[ $INDEX -eq 9 ]]; then
			clear_data
		elif [[ $INDEX -eq 7 ]]; then
			local result=$(find_result)
		else
			break
		fi
	done
}

main

