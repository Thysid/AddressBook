# Getting the filename from the command line
fname=$1
#functions
Sort()
{
	sort -n $fname > temp.csv	# Numerically sorting and sorting the output in a file
	chmod 777 temp.csv		# In case of an error, the permissions are changed and the command is applied again
	sort -n $fname > temp.csv
	mv temp.csv $fname 	# moves the sorted file into the inputted file, deletes the sorted file
}
Sort # Sorts the file as soon as the Program starts
# the function that Splits the file properly into columns
Split(){
	awk '{
	    	c=0
	    	$0=$0","                                   # adds a commma to the end of line
		while($0) {
			delimiter=""
			if (c++ > 0){  # Evaluate and then increment c
		   		 delimiter="'$delimiter'"
	       	 	}

			match($0,/ *"[^"]*" *,|[^,]*,/)		# matches where the first comma in in the line
			s=substr($0,RSTART,RLENGTH)             # save what matched in f
			gsub(/^ *"?|"? *,$/,"",s)               # remove extra stuff
			printf (delimiter s "\t")
			$0=substr($0,RLENGTH+1)    		# cuts what is matched from the $0
	    	}
		printf ("\n")
	}' $1
}
List(){
	 Split $fname
}
Search(){
	read -p "Enter Entry number: " entrynumber 	# Asks the user for an entry number
	check1=$(grep "^$entrynumber," $fname | wc -w)	# Checks if the entry # that the user inputted in exists
	if [ $check1 -gt 0 ]; then
		grep -w "^$entrynumber" $fname | Split	# Gets the Contact and displays it
	else
		echo "Contact does not exist!"
	fi
}
List_Search_Selection()		#the menu for List/ Search
{
	select List_Search_input in "List" "Search" "Exit to Main menu" "Exit"
	do
	case "$List_Search_input" in
		"List")
		List
		;;
		"Search")
		Search
		;;
		"Exit to Main menu")
		echo "Exiting to Main Menu"
		break
		;;
		"Exit")
		echo "Exiting Shell"
		exit
		;;
		*)
		echo -e "Not an option/Invalid entry"
		;;
	esac
	done
}
Create()
{
	echo "Add Contact"
	read -p "Enter Entry number: " entrynumber
	check2=$(grep "^$entrynumber," $fname | wc -w)		#checks if the Entry Number is in the file or not
	if [ $check2 -gt 0 ]; then
		echo "Entry already exists"
	else
		#Prompting the user for information about the new contact
		read -p "What is the their first name? " namef
		read -p "What is the their last name? " namel
		read -p "Where do they work at? " company
		read -p "Where is their address? " address
		read -p "What city do they live in? " city
		read -p "What county do they live in? " county
		read -p "What are the initials of the state they live in? " state
		read -p "What is their Zip code? " zipcode
		read -p "What is their Phone number? " phonenumber
		read -p "What is their email? " email
		New_Contact=$(echo $entrynumber,$namef,$namel,$company,$address,$city,$county,$state,$zipcode,$phonenumber,$email)	# Creates the Contact
		echo $New_Contact >> $fname 	# Adds the Contact to the file
		echo "Contact Added!"
	fi
	Sort	#sorts the file so that no mismatched entries occur
}
Edit()
{
	read -p "Enter Entry number for editing: " entrynumber
	check3=$(grep "^$entrynumber," $fname | wc -w)
	if [ $check3 -gt 0 ]; then	# Checks if the Entry exists
		Old_Contact=$(grep "^$entrynumber," $fname)	# Sets the variable as the Old Contact
		grep -w "^$entrynumber," $fname | Split		# Displays the Old contact for easier editing
		#Prompting the user for information about editing contact
		read -p "What is the their new first name? " namef
		read -p "What is the their new last name? " namel
		read -p "Where do they work at now? " company
		read -p "Where is their new address? " address
		read -p "What city do they live in now? " city
		read -p "What county do they live in now? " county
		read -p "What are the initials of the state they live in? " state
		read -p "What is their new Zip code? " zipcode
		read -p "What is their new Phone number? " phonenumber
		read -p "What is their new email? " email
		New_Contact=$(echo $entrynumber,$namef,$namel,$company,$address,$city,$county,$state,$zipcode,$phonenumber,$email)	# Makes the new Contact
		sed -i "s/${Old_Contact}/${New_Contact}/g" $fname	# Replaces the Old Contact with the new Contact
		echo "Contact Edited!"	
	else
		echo "Contact does not exist!"
	fi	
}
Delete()
{
	read -p "Enter Entry number for Deletion: " entrynumber
	check=$(grep "^$entrynumber," $fname | wc -w)	# Checks if the Contact exists
	if [ $check -gt 0 ]; then
		Old_Contact=$(grep "^$entrynumber," $fname) # sets a variable to the Contact
		sed -i "/${Old_Contact}/d" ./$fname	# Deletes the Contact
		echo "Contact Deleted"
	else
		echo "Contact does not exist!"
	fi
}
# Main Menu
select Menu_Input in "List/Search" "Add Contact" "Edit Contact" "Delete Contact" "Exit"
do
case "$Menu_Input" in
	"List/Search")
	List_Search_Selection
	;;
	"Add Contact")
	Create
	;;
	"Edit Contact")
	echo "Edit Contact"
	Edit
	;;
	"Delete Contact")
	echo "Delete Contact"
	Delete
	;;
	"Exit")
	echo "Exiting Shell"
	exit 0
	;;
	*)
	echo -e "Not an option/Invalid entry"
	;;
esac
done
