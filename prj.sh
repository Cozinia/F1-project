#!/bin/bash

add(){
	id=3
	read -p "Nume: " nume
	read -p "Numar: " numar
	read -p "Echipa: " echipa
	read -p  "Punctaj general: " punctajGeneral
	read -p "Nume cursa: " numeCursa
	read -p "Punctaj cursa: " punctajCursa
	read -p "Pozitie grid: " pozitieGrid
	echo "$id,$numar,$nume,$echipa,$punctajGeneral,$numeCursa,$punctajCursa,$pozitieGrid" >> formula1.csv
	echo "Driver saved in csv"
}

display(){
	echo "Drivers: "
	while IFS="," read ID Numar Nume Echipa PunctajGeneral NumeCursa PunctajCursa PozitieGrid
		do
			printf "%-5s|%-5s|%-20s|%-20s|%-20s|%-20s|%-20s|%-20s|\n" "ID" "Numar" "Nume" "Echipa" "Punctaj general" "Nume cursa" "Punctaj cursa" "Pozitie grid" 
			printf "%-5s|%-5s|%-20s|%-20s|%-20s|%-20s|%-20s|%-20s|\n" "$ID" "$Numar" "$Nume" "$Echipa" "$PunctajGeneral" "$NumeCursa" "$PunctajCursa" "$PozitieGrid"

		done < <(tail -n +2 "formula1.csv")
}


i=10
 while [ $i -ne 0 ]
	do
		echo "Choose option: "
		echo "1.Add driver"
		echo "2.Modify driver"
		echo "3.Delete driver"
		echo "4.Display drivers"
		echo "0.Exit program"
		read i

		if [ $i -gt 5 ]
			then
				echo "Chose a valid option"
		fi

		case $i in
			1)add;;
			4)display;;
		esac
	done
