#!/bin/bash

original="formula1.csv"
users_file="users.csv"
sortColumn=0
reverseOption="-r"
regex_email="^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"
regex_number="^[0-9]+$"
regex_password="^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[@$!%*?&]).{8,}$" #lungime intre 3 si 32 de caractere

function checkRegexString() {
  local input="$1"
  local pattern="^[A-Za-z]+([ ][A-Za-z]+)*$"

  if [[ "$input" =~ $pattern ]]; then
    return 1  
  else
    return 0  
  fi
}

function checkRegexNumber() {
  local input="$1"
  local pattern="^[0-9]+$"

  if [[ "$input" =~ $pattern ]]; then
    return 1  
  else
    return 0  
  fi
}

add(){
	id=$(tail -n 1 formula1.csv | cut -d',' -f 1) #returneaza ultimul ID din fisierul csv
	(( id++ ))
	read -p "Nume: " nume
	checkRegexString "$nume"

	while [[ $? -eq 0 ]]; do
	  echo "Inputul nu se potriveste cu pattern-ul stabilit."
	  read -p "Nume: " nume
	  checkRegexString "$nume"
	done

	read -p "Numar: " numar
	checkRegexNumber "$numar"

	while [[ $? -eq 0 ]]; do
	  echo "Inputul nu se potriveste cu pattern-ul stabilit."
	  read -p "Numar: " numar
	  checkRegexNumber "$numar"
	done

	read -p "Echipa: " echipa
	checkRegexString "$echipa"

	while [[ $? -eq 0 ]]; do
	  echo "Inputul nu se potriveste cu pattern-ul stabilit."
	  read -p "Echipa: " echipa
	  checkRegexString "$echipa"
	done

	read -p "Punctaj general: " punctajGeneral
	checkRegexNumber "$punctajGeneral"

	while [[ $? -eq 0 ]]; do
	  echo "Inputul nu se potriveste cu pattern-ul stabilit."
	  read -p "Punctaj general: " punctajGeneral
	  checkRegexNumber "$punctajGeneral"
	done

	read -p "Nume cursa: " numeCursa
	checkRegexString "$numeCursa"

	while [[ $? -eq 0 ]]; do
	  echo "Inputul nu se potriveste cu pattern-ul stabilit."
	  read -p "Nume cursa: " numeCursa
	  checkRegexString "$numeCursa"
	done

	read -p "Punctaj cursa: " punctajCursa
	checkRegexNumber "$punctajCursa"

	while [[ $? -eq 0 ]]; do
	  echo "Inputul nu se potriveste cu pattern-ul stabilit."
	  read -p "Punctaj cursa: " punctajCursa
	  checkRegexNumber "$punctajCursa"
	done

	read -p "Pozitie grid: " pozitieGrid
	checkRegexNumber "$pozitieGrid"

	while [[ $? -eq 0 ]]; do
	  echo "Inputul nu se potriveste cu pattern-ul stabilit."
	  read -p "Pozitie grid: " pozitieGrid
	  checkRegexNumber "$pozitieGrid"
	done

	# Datele introduse de utilizator vor fi salvate in fisierul formula1.csv
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
    regex_modify="^[1-7]$"

    # aici se modifica datele despre un driver dat
    read -p "Scrie ID-ul pilotului pe care vrei sa îl modifici: " driverID

    driver_Line=$(grep -n "^$driverID," "$original" | cut -d ':' -f1) # se cauta linia pe care se afla pilotul

    option=10

    while [ $option -ne 0 ]; do
        echo "Alegeti optiunea dorita:"
        echo "1.Schimba numele"
        echo "2.Schimba numarul"
        echo "3.Schimba echipa"
        echo "4.Schimba punctajul in clasamentul general"
        echo "5.Schimba numele cursei"
        echo "6.Schimba rezultatul cursei"
        echo "7.Schimba pozitia de pe grid"
        echo "0.Inapoi"
        read -p "Option: " option

        if [[ $option =~ $regex_modify ]]; then
            contents=$(awk -F',' -v line="$driver_Line" 'NR == line {print}' "$original") # se extrage continutul liniei pilotul
            IFS=',' read -r ID Numar Nume Echipa PunctajGeneral NumeCursa PunctajCursa PozitieGrid <<<"$contents" # se plaseaza continutul variabilei "contents" in aceste campuri

            case $option in
                1)
                    read -p "Nume: " newName
                    checkRegexString "$newName"
                    while [ $? -eq 0 ]; do
                    	echo "Introduceti o optiune valida!"S
                        read -p "Nume: " newName
                        checkRegexString "$newName"
                    done
                    Nume="$newName"
                    ;;
                2)
                    read -p "Numar: " newNumar
                    checkRegexNumber "$newNumar"
                    while [ $? -eq 0 ]; do
                    	echo "Introduceti o optiune valida!"
                        read -p "Numar: " newNumar
                        checkRegexNumber "$newNumar"
                    done
                    Numar="$newNumar"
                    ;;
                3)
                    read -p "Ehipa: " newEchipa
                    checkRegexString "$newEchipa"
                    while [ $? -eq 0 ]; do
                    	echo "Introduceti o optiune valida!"
                        read -p "Echipa: " newEchipa
                        checkRegexString "$newEchipa"
                    done
                    Echipa="$newEchipa"
                    ;;
                4)
                    read -p "Care este punctajul pilotului in clasamentul general? " newPunctajGeneral
                    checkRegexNumber "$newPunctajGeneral"
                    while [ $? -eq 0 ]; do
                    	echo "Introduceti o optiune valida!"
                        read -p "Care este punctajul pilotului in clasamentul general? " newPunctajGeneral
                        checkRegexNumber "$newPunctajGeneral"
                    done
                    PunctajGeneral="$newPunctajGeneral"
                    ;;
                5)
                    read -p "Care este noul nume al cursei? " newNumeCursa
                    checkRegexString "$newNumeCursa"
                    while [ $? -eq 0 ]; do
                    	echo "Introduceti o optiune valida!"
                        read -p "Care este noul nume al cursei? " newNumeCursa
                        checkRegexString "$newNumeCursa"
                    done
                    NumeCursa="$newNumeCursa"
                    ;;
                6)
                    read -p "Care este noul rezultat al cursei? " newPunctajCursa
                    checkRegexNumber "$newPunctajCursa"
                    while [ $? -eq 0 ]; do
                    	echo "Introduceti o optiune valida!"
                        read -p "Care este noul rezultat al cursei? " newPunctajCursa
                        checkRegexNumber "$newPunctajCursa"
                    done
                    PunctajCursa="$newPunctajCursa"
                    ;;
                7)
                    read -p "Pozitia de pe grid: " newPozitieGrid
                    checkRegexNumber "$newPozitieGrid"
                    while [ $? -eq 0 ]; do
                    	echo "Introduceti o optiune valida!"
                        read -p "Pozitia de pe grid: " newPozitieGrid
                        checkRegexNumber "$newPozitieGrid"
                    done
                    PozitieGrid="$newPozitieGrid"
                    ;;
            esac

            sed -i "${driver_Line}s/.*/$ID,$Numar,$Nume,$Echipa,$PunctajGeneral,$NumeCursa,$PunctajCursa,$PozitieGrid/" "$original" # se inlocuieste linia cu noile valori date de utilizator
        else
            echo "Introduceti o optiune valida!"
        fi
    done
}




delete() {
    read -p "Introduceti ID-ul pilotului: " deleteID
    checkRegexNumber "$deleteID"
    while [ $? -eq 0 ]; do
        read -p "Introduceti ID-ul pilotului (doar numere): " deleteID
        checkRegexNumber "$deleteID"
    done

    driver_Line=$(grep -n "^$deleteID," "$original" | cut -d ':' -f1) # se cauta linia pe care se afla pilotul
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
regex_sort="^[1-4]$"
	while [ $sortOption -ne 0 ]
		do
			echo "Alegeti optiunea dorita:"
			echo "1.Sorteaza dupa clasamentul general"
			echo "2.Sorteaza dupa clasamentul ultimei curse"
			echo "3.Sorteaza dupa numar"
			echo "4.Sorteaza dupa pozitia pe grid"
			echo "0.Inapoi"
			read sortOption
			
			if [[ $sortOption =~ $regex_sort ]]
				then
					case $sortOption in
						1)sortColumn=5;;
						2)sortColumn=7;;
						3)sortColumn=2;;
						4)sortColumn=8
						 reverseOption=" "
						 ;;
					esac
					sortDriversFunc
				else
					echo "Introduceti o optiune valida!"
			fi
			
			
		done
}

readUsersFromFile(){
read -p "Username: " inputUsername
if [[ "$inputUsername" =~ $regex_email ]] #se verifica daca input-ul introdus de utilizator respecta pattern-ul regex al unei adrese de email
	then
		read -p "Password: " inputPassword
		if echo "$inputPassword" | grep -qP '^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[@$!%*?&]).{8,}$'; then # verifica daca inputPassword respecta pattern-ul regex al unei parole
			while IFS="," read ID Email Parola
					do

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
				else
					echo "Email-ul sau parola nu sunt valide!"
		fi
	else
		 echo "Introduceti o adresa de email valida!"
		 return 0
	fi
		

}

userMenu(){
    p=10
    regex_userMenu="^[0-6]$"
    while [ $p -ne 0 ]
    	do
		echo "Alegeti optiunea dorita:"
		echo "1.Adauga pilot"
		echo "2.Modifica pilot"
		echo "3.Sterge un pilot"
		echo "4.Afiseaza pilotii"
		echo "5.Sorteaza pilotii"
		echo "6.Delogare"
		echo "0.Iesire"
		read p
		if [[ $p =~ $regex_userMenu ]]
			then
				 case $p in
				    1) add ;;
				    2) modify ;;
				    3) delete ;;
				    4) display ;;
				    5) menuSortDrivers ;;
				    6) mainMenu;;
				esac
			else
				echo "Introduceti o optiune valida!"
				userMenu
		fi
    done

}

loginPage(){
 while [ $? -ne 1 ]
	do
		readUsersFromFile
	done
if [ $? -eq 1 ]
	then
		userMenu
fi
			
					
}

createAccount(){
	id=$(tail -n 1 users.csv | cut -d',' -f 1) #returneaza ultimul ID din fisierul csv
	(( id++ ))
	read -p "Email: " email
	if [[ "$email" =~ $regex_email ]] #se verifica daca input-ul introdus de utilizator respecta pattern-ul regex al unei adrese de email
		then
		        read -p "Parola: " parola
		        if echo "$parola" | grep -qP '^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[@$!%*?&]).{8,32}$'; then # verifica daca inputPassword respecta pattern-ul regex al unei parole
				echo "$id,$email,$parola" >> users.csv
				echo "Utilizatorul a fost salvat cu succes!"
				loginPage
			fi

		else
		    echo "Introduceti o adresa de email valida!"
		    createAccount
	fi
}

mainMenu(){
	userOption=0
	regex_mainMenu="^[1-2]$"
	echo "Bun venit in lumea F1!"
	echo "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
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
	if [[ $userOption =~ $regex_mainMenu ]]
		then
			case $userOption in
				1)loginPage;;
				2)createAccount;;
			esac
		else
			echo "Introduceti o optiune valida!"
			mainMenu
	fi
		
}

mainMenu
