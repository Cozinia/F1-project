#!/bin/bash

original="formula1.csv"
temp_file="temp_formula.csv"
users_file="users.csv"
sortColumn=0
reverseOption="-r"

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
	echo "$nume a fost salvat cu succes!"
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
	
	#aici se modifica datele despre un driver dat
	read -p "Scrie ID-ul pilotului pe care vrei sa îl modifici: " driverID
	driver_Line=$(grep -n "^$driverID," "$original" | cut -d ':' -f1) #se cauta linia pe care se afla pilotul
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
		
		contents=$(awk -F',' -v line="$driver_Line" 'NR == line {print}' "$original") #se extrage continutul liniei pilotul
	IFS=',' read -r ID Numar Nume Echipa PunctajGeneral NumeCursa PunctajCursa PozitieGrid <<< "$contents" #se plaseaza continutul variabilei "contents" in aceste campuri
		
		case $option in
			1)read -p "Nume: " Nume;;
			2)read -p "Numar: " Numar;;
			3)read -p "Ehipa: " Echipa;;
			4)read -p "Care este punctajul pilotului in clasamentul general? " PunctajGeneral;;
			5)read -p "Care este noul nume al cursei? " NumeCursa;;
			6)read -p "Care este noul rezultat al cursei? " PunctajCursa;;
			7)read -p "Pozitia de pe grid: " PozitieGrid;;

		esac
		
		sed -i "${driver_Line}s/.*/$ID,$Numar,$Nume,$Echipa,$PunctajGeneral,$NumeCursa,$PunctajCursa,$PozitieGrid/" "$original" #se inlocuieste linia cu noile valori date de utilizator
		
		done
}



delete(){

	read -p "Introduceti ID-ul pilotului: "  deleteID
	driver_Line=$(grep -n "^$deleteID," "$original" | cut -d ':' -f1) #se cauta linia pe care se afla pilotul
	sed -i "${driver_Line}d" "$original"

}

sortDriversFunc(){
	
	sorted_data=$(tail -n +2 "$original" | sort -t',' -k${sortColumn} -n $reverseOption) #se sorteaza fizierul CSV incepand de la cea de-a doua linie
	printf "|%-5s|%-5s|%-20s|%-20s|%-20s|%-15s|%-10s|%-12s|\n" "ID" "Numar" "Nume" "Echipa" "Punctaj general" "Nume cursa" "Punctaj cursa" "PozitieGrid" 
	printf "|-----|-----|--------------------|--------------------|--------------------|---------------|-------------|------------|\n"
	while IFS= read -r line
		 do
    			IFS=',' read -r ID Numar Nume Echipa PunctajGeneral NumeCursa PunctajCursa PozitieGrid <<< "$line"
    			printf "|%-5s|%-5s|%-20s|%-20s|%-20s|%-15s|%-13s|%-12s|\n"  "$ID" "$Numar" "$Nume" "$Echipa" "$PunctajGeneral" "$NumeCursa" "$PunctajCursa" "$PozitieGrid"
    			printf "|-----|-----|--------------------|--------------------|--------------------|---------------|-------------|------------|\n"
		done <<< "$sorted_data"
}

menuSortDrivers(){
sortOption=10
	while [ $sortOption -ne 0 ]
		do
			echo "Alegeti optiunea dorita:"
			echo "1.Sorteaza dupa clasamentul general"
			echo "2.Sorteaza dupa clasamentul ultimei curse"
			echo "3.Sorteaza dupa numar"
			echo "4.Sorteaza dupa pozitia pe grid"
			echo "0.Inapoi"
			read sortOption
			
			if [ $sortOption -gt 5 ]
			then
				echo "Introduceti o optiune valida!"
			fi
			
			case $sortOption in
				1)sortColumn=5;;
				2)sortColumn=7;;
				3)sortColumn=2;;
				4)sortColumn=8
				 reverseOption=" "
				 ;;
			esac
			
			if [ $sortOption -ne 0 ]
				then
				 	sortDriversFunc
				fi
		done
}

readUsersFromFile(){
read -p "Username: " inputUsername
read -p "Password: " inputPassword
while IFS="," read ID Email Parola
		do
			echo "Username: $Email Password: $Parola"
			if [ "$inputUsername" = "$Email" ]
				then
					if [ "$inputPassword" = "$Parola" ]
						then	
							return 1
						else
							return 0
					fi
				
			fi	
		done < <(tail -n +2 "$users_file")
		return 0
}

userMenu(){
    p=10
    while [ $p -ne 0 ]
    	do
		echo "Alegeti optiunea dorita:"
		echo "1.Adauga pilot"
		echo "2.Modifica pilot"
		echo "3.Sterge un pilot"
		echo "4.Afiseaza pilotii"
		echo "5.Sorteaza pilotii"
		echo "0.Iesire"
		read p

		if [ $p -gt 6 ]; then
		    echo "Introduceti o optiune valida!"
		fi

		 case $p in
		    1) add ;;
		    2) modify ;;
		    3) delete ;;
		    4) display ;;
		    5) menuSortDrivers ;;
        esac
    done

}

loginPage(){
	readUsersFromFile
	if [ $? -eq 1 ]
		then
			userMenu
		else
			echo "Wrong username or password!"
			loginPage
	fi
					
}

createAccount(){
	id=$(tail -n 1 users.csv | cut -d',' -f 1) #returneaza ultimul ID din fisierul csv
	(( id++ ))
	read -p "Email: " email
	read -p "Parola: " parola
	echo "$id,$email,$parola" >> users.csv
	echo "Utilizatorul a fost salvat cu succes!"
	loginPage

}

mainMenu(){
	userOption=0
	echo "Bun venit in lumea F1!"
	echo "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⢀⣀⣀⣀⠀⠀⠀⠀⢀⣀⣀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⢸⣿⣿⡿⢀⣠⣴⣾⣿⣿⣿⣿⣇⡀⠀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⢸⣿⣿⠟⢋⡙⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣶⣿⡿⠓⡐⠒⢶⣤⣄⡀⠀⠀
⠀⠸⠿⠇⢰⣿⣿⡆⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⣿⣿⡷⠈⣿⣿⣉⠁⠀
⠀⠀⠀⠀⠀⠈⠉⠀⠈⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠀⠈⠉⠁⠀⠈⠉⠉⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
	echo "Alegeti optiunea dorita:"
	echo "1.Am cont"
	echo "2.Vreau cont"
	read userOption
	case $userOption in
		1)loginPage;;
		2)createAccount;;
	esac
		
}

mainMenu
