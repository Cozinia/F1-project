#!/bin/bash

original="formula1.csv"
temp_file="temp_formula.csv"

add(){
	id=$(tail -n 1 formula1.csv | cut -d',' -f 1) #returneaza ultimul ID din fisierul csv
	(( id++ ))
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

	printf "|%-5s|%-5s|%-20s|%-20s|%-20s|%-15s|%-10s|%-12s|\n" "ID" "Numar" "Nume" "Echipa" "Punctaj general" "Nume cursa" "Punctaj cursa" "PozitieGrid" 
	printf "|-----|-----|--------------------|--------------------|--------------------|---------------|-------------|------------|\n"
	while IFS="," read ID Numar Nume Echipa PunctajGeneral NumeCursa PunctajCursa PozitieGrid
		do
			printf "|%-5s|%-5s|%-20s|%-20s|%-20s|%-15s|%-13s|%-12s|\n" "$ID" "$Numar" "$Nume" "$Echipa" "$PunctajGeneral" "$NumeCursa" "$PunctajCursa" "$PozitieGrid" 
			printf "|-----|-----|--------------------|--------------------|--------------------|---------------|-------------|------------|\n"


		done < <(tail -n +2 "formula1.csv")
}

modify() {
	
	#aici modific datele despre un driver dat
	read -p "Scrie ID-ul pilotului pe care vrei sa îl modifici: " driverID
	driver_Line=$(grep -n "^$driverID," "$original" | cut -d ':' -f1) #search for the column of the driver
	echo "$driver_Line"
	option=10
	while [ $option -ne 0 ]
		do
			echo "Alegeti optiunea dorita:"
			echo "1.Schimba numele"
			echo "2.Schimba numarul"
			echo "3.Schimba echipa"
			echo "4.Schimba punctajul in clasamentul general"
			echo "5.Schimba numele cursei"
			echo "6.Schimba rezultatul cursei"
			echo "7.Schimba pozitia de pe grid"
			echo "0.Inapoi"
			read option
			if [ $option -gt 7 ]
				then
					echo "Introduceti o optiune valida!"
			fi
		
		contents=$(awk -F',' -v line="$driver_Line" 'NR == line {print}' "$original") #extract the contents of the driver's line
	IFS=',' read -r ID Numar Nume Echipa PunctajGeneral NumeCursa PunctajCursa PozitieGrid <<< "$contents" #place the contents of the variable "contents" in those fields
		
		case $option in
			1)read -p "Nume: " Nume;;
			2)read -p "Numar: " Numar;;
			3)read -p "Ehipa: " Echipa;;
			4)read -p "Care este punctajul pilotului in clasamentul general? " PunctajGeneral;;
			5)read -p "Care este noul nume al cursei? " NumeCursa;;
			6)read -p "Care este noul rezultat al cursei? " PunctajCursa;;
			7)read -p "Pozitia de pe grid: " PozitieGrid;;

		esac
		
		sed -i "${driver_Line}s/.*/$ID,$Numar,$Nume,$Echipa,$PunctajGeneral,$NumeCursa,$PunctajCursa,$PozitieGrid/" "$original" #replace the line with the new values
		
		done
}



delete(){

	read -p "Introduceti ID-ul pilotului: "  deleteID
	driver_Line=$(grep -n "^$deleteID," "$original" | cut -d ':' -f1) #search for the column of the driver
	sed -i "${driver_Line}d" "$original"

}


i=10
 while [ $i -ne 0 ]
	do
		echo "Alegeti optiunea dorita:"
		echo "1.Adauga pilot"
		echo "2.Modifica pilot"
		echo "3.Sterge un pilot"
		echo "4.Afiseaza pilotii"
		echo "0.Iesire"
		read i

		if [ $i -gt 5 ]
			then
				echo "Introduceti o optiune valida!"
		fi

		case $i in
			1)add;;
			2)modify;;
			3)delete;;
			4)display;;
		esac
	done
