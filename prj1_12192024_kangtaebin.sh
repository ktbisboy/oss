#!/bin/bash

f1="$1"
f2="$2"
f3="$3"

echo "--------------------------"
echo "User Name: 강태빈"
echo "Student Number: 12192024"
echo "[ MENU ]"
echo "1. Get the data of the movie identified by a specific 'movie id' from 'u.item'"
echo "2. Get the data of action genre movies from 'u.item'"
echo "3. Get the average 'rating’ of the movie identified by specific 'movie id' from 'u.data’"
echo "4. Delete the ‘IMDb URL’ from ‘u.item"
echo "5. Get the data about users from 'u.user’"
echo "6. Modify the format of 'release date' in 'u.item’"
echo "7. Get the data of movies rated by a specific 'user id' from 'u.data'"
echo "8. Get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'"
echo "9. Exit"
echo "--------------------------"

while true; do
	read -p "Enter your choice [ 1-9 ] " choice
	
	case $choice in
		1) echo ""
		read -p "Please enter 'movie id' (1~1682):" movie
		echo ""
		awk -v movie_id="$movie" 'NR==movie_id {print; exit}' "$f1"
		;;
		2) echo ""
		read -p "Do you want to get the data of 'action' genre movies from 'u.item'?(y\n):" answer
		if [ "$answer" = "y" ]; then
			echo ""
			awk -F '|' '$7==1 && count < 10 {print($1, $2); count++}' "$f1"
		fi
		;;
		3) echo ""
		read -p "Please enter the 'moive id' (1~1682):" movie2
		echo ""
		awk -v movie_id="$movie2" '$2==movie_id {sum+=$3; count++} END {printf("average rating of %s: %.5f\n", movie_id, sum/count)}' "$f2"
		;;
		4) echo ""
		read -p "Do you want to delete the 'IMDb URL' from 'u.item'?(y\n):" answer2
		if [ "$answer2" = "y" ]; then
			echo""
			awk -F '|' 'NR <= 10 {for(i=1; i<=NF; i++) if(i!=5) {printf "%s|", $i} printf "\n"}' "$f1"	
		fi
		;;
		5) echo ""
		read -p "Do you want to get the data about users from 'u.user'?(y\n):" answer3
		if [ "$answer3" = "y" ]; then
			echo""
			awk -F '|' 'NR<=10 {gender = ($3 == "M" ? "male" : "female"); printf("user %s is %s years old %s %s\n", $1, $2, gender, $4)}' "$f3"
		fi
		;;
		6) echo ""
		read -p "Do you want to Modify the format of 'release data' in 'u.item'?(y\n):" answer4
		if [ "$answer4" = "y" ]; then
			echo ""
		awk -F '|' 'NR >= 1673 {
			months = "JanFebMarAprMayJunJulAugSepOctNovDec";
			split($3, date, "-");
			new_date = date[3] sprintf("%02d", index(months, date[2])/3) sprintf("%02d", date[1]);
			for (i = 1; i <= NF; i++) {
				if (i == 3) printf("%s", new_date);
				else printf("%s", $i);
				if (i < NF) printf("|");
			}
			printf("\n");
		}' "$f1"
		fi
		;;
		7) echo ""
		read -p "Please enter the 'user id' (1~943):" uid
		echo ""
		awk -v u_id="$uid" 'NR==FNR { 
			if ($1 == u_id) movie[$2] = $2; next; 
			} 
			{ 
			if ($1 in movie) movie2[$1] = $2; 
			} 
			END { 
				n = 0; 
				for (i in movie2) { printf("%s|", i); }
				printf("\n\n");
				for (i in movie2) { 
					printf("%s|%s\n", i, movie2[i]); 
					n++; 
					if (n == 10) break; 
				}
			}' "$f2" FS="|" "$f1" | sort -n
		;;
		8) echo ""
		read -p "Do you want to get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'?(y\n):" answer5
		if [ "$answer5" = "y" ]; then
			echo ""
			awk -F "|" 'NR==FNR && $2 >= 20 && $2 <= 29 && $4 == "programmer" { 
				users[$1] = $1; } 
				NR!=FNR { 
				if ($1 in users) { 
					ratings[$2] += $3; counts[$2]++; 
				} 
			} END { 
				for (movie_id in ratings) { 
					average = ratings[movie_id] / counts[movie_id]; 
					average_str = sprintf("%.5f", average);
					sub(/\.?0*$/, "", average_str);
					printf("%d %s\n", movie_id, average_str);
				} 
			}' "$f3" FS="\t" "$f2" | sort -n						
		fi
		;;
		9) echo "Bye!"
		exit 0
		;;
	esac
	echo ""
done
