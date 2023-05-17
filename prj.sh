#!/bin/bash
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
    # aici modific datele despre un driver dat
    read -p "Scrie ID-ul pilotului pe care vrei sa îl modifici: " driverID
    if grep -q "^$driverID," formula1.csv; then
        read -p "Introdu noile informații în ordinea dat(Numar, Nume, Echipa, Punctaj general, Nume cursa, Punctaj cursa, Pozitie grid): " numar nume echipa punctajGeneral numeCursa punctajCursa pozitieGrid
        sed -i "s/^$driverID,[^,]*/$driverID,$numar,$nume,$echipa,$punctajGeneral,$numeCursa,$punctajCursa,$pozitieGrid/" formula1.csv
        echo "Am modificat pilotul!!"
    else
        echo "Nu exista pilot cu id-ul $driverID :("
    fi
}

delete(){

	read -p "Introduceti ID-ul pilotului: "  deleteID
	

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
			2)modify;;
			3)delete;;
			4)display;;
		esac
	done
