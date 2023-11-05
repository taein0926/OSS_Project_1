#! /bin/bash

#12223725 김태인

echo "--------------------------
User name: $(whoami)
Student Number: 12223725
[ Menu ]
1. Get the data of the movie identified by a specific 'movie id' from 'u.item'
2. Get the data of action genre movies from 'u.item’
3. Get the average 'rating’ of the movie identified by specific 'movie id' from 'u.data’
4. Delete the ‘IMDb URL’ from ‘u.item
5. Get the data about users from 'u.user’
6. Modify the format of 'release date' in 'u.item’
7. Get the data of movies rated by a specific 'user id' from 'u.data'
8. Get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'
9. Exit
--------------------------"

while true
do
	echo -n "Enter your choice [ 1-9 ] "
	read orderN
	echo ""
	case $orderN in
		1)
			echo -n "Please enter 'movie id'(1~1682):"
			read movieID_1
			echo ""
			awk -F'|' -v id=$movieID_1 '{if ($1 == id) {print}}' "$1"
			;;
		2)
			echo -n "Do you want to get the data of ‘action’ genre movies from 'u.item’?(y/n):"
			read choice_2
			echo ""
			if [ "$choice_2" = "y" ] || [ "$choice_2" = "Y" ] ; then
				awk -F'|' '{if ($7 == 1) {print $1, $2}}' "$1" | head -n 10
			elif [ "$choice_2" = "n" ] || [ "$choice_2" = "N" ] ; then
				continue
			else
				echo "Please enter y or n"
			fi
			;;
		3)
			echo -n "Please enter the 'movie id’(1~1682):"
			read movieID_3
			echo ""
			awk -F'\t' -v id=$movieID_3 '{if ($2 == id) {total+=$3; count++}} END {if (count > 0) print "average rating of "id": " total/count; else print "No ratings found for this movie"}' "$2"
			;;
		4)
			echo -n "Do you want to delete the ‘IMDb URL’ from ‘u.item’?(y/n):"
			read choice_4
			echo ""
			if [ "$choice_4" = "y" ] || [ "$choice_4" = "Y" ] ; then
				sed -E '10q; s/([^|]*)\|([^|]*)\|([^|]*)\|([^|]*)\|[^|]*\|(.*)/\1|\2|\3|\4|\5/' "$1"
			elif [ "$choice_4" = "n" ] || [ "$choice_4" = "N" ]; then
				echo "No changes made."
			else
                                echo "Please enter y or n"
			fi
			;;
		5)
			echo -n "Do you want to get the data about users from ‘u.user’?(y/n):"
			read choice_5
			echo ""
			if [ "$choice_5" = "y" ] || [ "$choice_5" = "Y" ] ; then
				sed -nE '1,10s/([^|]*)\|([^|]*)\|([^|]*)\|([^|]*)\|.*/user \1 is \2 years old \3 \4/p' "$3"
			elif [ "$choice_5" = "n" ] || [ "$choice_5" = "N" ] ; then
				continue
			else
				echo "Please enter y or n"
			fi
			;;
		6)
			echo -n "Do you want to Modify the format of ‘release data’ in ‘u.item’?(y/n):"
			read choice_6
			echo ""
			if [ "$choice_6" = "y" ] || [ "$choice_6" = "Y" ] ; then
				sed -e 's/-Jan-/-01-/g' -e 's/-Feb-/-02-/g' -e 's/-Mar-/-03-/g' -e 's/-Apr-/-04-/g' -e 's/-May-/-05-/g' -e 's/-Jun-/-06-/g' -e 's/-Jul-/-07-/g' -e 's/-Aug-/-08-/g' -e 's/-Sep-/-09-/g' -e 's/-Oct-/-10-/g' -e 's/-Nov-/-11-/g' -e 's/-Dec-/-12-/g' "$1" | sed -E 's/([0-9]+)-([0-9]+)-([0-9]{4})/\3\2\1/g' | tail -10
			elif [ "$choice_6" = "n" ] || [ "$choice_6" = "N" ] ; then
				continue
			else
                                echo "Please enter y or n"
			fi
			;;
		7)
			echo -n "Please enter the ‘user id’(1~943):"
			read userID
			echo ""
			movie_ids=$(awk -v user_id="$userID" -F "\t" '$1 == user_id {print $2}' "$2" | sort -n)
			echo ""
			echo $movie_ids | tr ' ' '|'
			echo ""
			count=0
			for movie_id in $movie_ids
			do
				if [ $count -eq 10 ]
				then
					break
				fi
				title=$(awk -v movie_id="$movie_id" -F "|" '$1 == movie_id {print $2}' "$1")
				echo "$movie_id|$title"
				((count++))
			done
			;;
		8)
			echo -n "Do you want to get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'?(y/n):"
			read choice_8
			echo ""
			if [ "$choice_8" = "y" ] || [ "$choice_8" = "Y" ] ; then
				programmers=$(awk -F "|" '$2 >= 20 && $2 <= 29 && $4 == "programmer" {print $1}' "$3")
				awk -v programmers="$programmers" -F "\t" 'BEGIN { OFS=FS; split(programmers, arr, " "); for (i in arr) { id[arr[i]] = 1; } } $1 in id { total[$2] += $3; count[$2]++; } END { for (movie_id in total) { printf("%d %.5f\n", movie_id, total[movie_id]/count[movie_id]); } }' "$2" | sort -n
			elif [ "$choice_8" = "n" ] || [ "$choice_8" = "N" ] ; then
				continue
			else
				echo "Please enter y or n"
			fi
			;;
		9)
			echo "Bye!"
			exit 0
			;;
		*)
			echo "You should enter a number between 1 and 9."
			;;
	esac
done
