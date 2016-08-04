# Setup some basic stuff
input_file=data.csv # What data file to use
debug=1 # Whether to show debug output
printer=OKI_DATA_CORP_B730n # The correct lpr printer name to use, this can be found using "lpstat -p"

# Function for debug echo
decho() {
	if [ $debug = 1 ]
	then
		echo "[DEBUG] $1"
	fi
}

# Function to find the serial number and print the stuff
find_serial() {

	if [[ -z $1 ]]
	then
		echo "Please enter a serial number."
		return 0
	fi

	serial=$1
	decho "Input serial is $serial"
	line=$(cat $input_file | grep $serial)
	decho "Input line is $line"

	LOC=$(echo $line | awk -F"," '{print $4}')
	decho "The location code is: $LOC"
	SCHOOLNAME=$(echo $line | awk -F"," '{print $5}')
	decho "The school name is: $SCHOOLNAME"
	ROLE=$(echo $line | awk -F"," '{print $7}')
	decho "The role is: $ROLE"
	PPISNUMBER=$(echo $line | awk -F"," '{print $3}')

	cp template.html ${serial}.html
	sed -i -e "s/SCHOOLNAME/${SCHOOLNAME}/g" ${serial}.html
	sed -i -e "s/LOC/${LOC}/g" ${serial}.html
	sed -i -e "s/SERVICECODE/${serial}/g" ${serial}.html
	sed -i -e "s/STAFFROLE/${ROLE}/g" ${serial}.html
	sed -i -e "s/PPISNUMBER/${PPISNUMBER}/g" ${serial}.html

	wkhtmltopdf ${serial}.html ${serial}.pdf

	echo "Printing shipping label now..."
	lpr -P $printer ${serial}.pdf

	decho "Removing temp label..."
	rm ${serial}.html
	rm ${serial}.html-e
	rm ${serial}.pdf

	# find the serial number and info here
	# make sure we actually found something, if not then tell the user we found nothing
	# copy template.html
	# replace relevant contents of template.html
	# print template.html
}

# Go script!
echo "Labeler Chooch v1.0"
read -p "Serial #: " serial_in
find_serial $serial_in

# Feed me serial numbers
while [[ ! $serial_in = "exit" ]]; do
	read -p "Serial #: " serial_in
	find_serial $serial_in
done
