#!/bin/bash

if ["$1" == ""]
then
	echo "Please provide path to screenshots html file"
	exit
fi
SteamScreenShots=$(cat "$1")

### Config ###
SteamLoginSecurePath="./steamLoginSecure.txt"
Debug=false
Agent="Mozilla/5.0 (X11; Linux x86_64; rv:108.0) Gecko/20100101 Firefox/108.0"
##############


cookies=""
if [[ $(wc -c $SteamLoginSecurePath) > 29 ]]
then
	cookies="-b steamLoginSecure=$(cat $SteamLoginSecurePath)"
fi
echo "$cookies"
function dateformat () {
	Months=("Jan" "Feb" "Mar" "Apr" "May" "Jun" "Jul" "Aug" "Sep" "Oct" "Nov" "Dec")
	screenMonth=0
	screenYear=$(echo "$1" | sed -e "s/.@.*//" -e "s/.*\ //")
	screenDay=$(echo "$1" | sed -e "s/,.*//" -e "s/.* //")
	screenTime=0
	if [[ $screenDay -lt 10 ]]
	then
		screenDay="0${screenDay}"
	fi
	for i in ${!Months[@]}
	do
		if [[ "$1" == *"${Months[$i]}"* ]]
		then
			screenMonth=$(($i+1))
			if [[ $screenMonth -lt 10 ]]
			then
				screenMonth="0${screenMonth}"
			fi
			break
		fi
	done
	#get hours
	screenTime=$(($screenTime + $(echo "$1" | sed -e "s/:.*//" -e "s/.*@.//" | bc ) * 100))
	if [[ "pm" == "$(echo $1 | sed -e "s/.*:..//")" ]] && [[ $screenTime -lt 1200 ]]
	then
		screenTime=$(($screenTime + 1200))
	fi
	#mins
	screenTime=$(( $screenTime + $(echo "$1" | sed -e "s/.*://" -e "s/...$//" | bc) ))
	echo "$screenYear-$screenMonth-$screenDay-${screenTime}00"
}
while read -r item
do
	ScreenshotPage="$(curl -s -A "$Agent" $cookies $item)"
	ItemID="$(echo "$item" | sed -e "s/.*?id=//" )"
	Image="$(echo "$ScreenshotPage" | grep \"ActualMedia\" | sed -e "s/.*href=\"//" -e "s/..target.*//")"
	Date="$(echo "$ScreenshotPage" | grep detailsStatRight | grep @ | sed -e "s/.*Right\">//" -e "s/<\/div>//")"
	appName="$(echo "$ScreenshotPage" | grep screenshotAppName | sed -e "s/.*\">//" -e "s/<\/div>//" -e "s/<\/a>//")"
	if $Debug
	then
		echo "--------------------------"
		echo -e "item link: $item\n"
		echo -e "Image link: $Image\n"
		echo -e "Nonformat Date: $Date"
		echo -e "App name: $appName"
		echo -e "Item ID: $ItemID"
		echo -e "$(dateformat "$Date")"
		echo "--------------------------"
	fi
	if [[ "$Image" == "" ]]
	then
		echo -e "Missing data. Hidden/private image?\n$item"
		continue
	fi
	# gets date
	Date="$(dateformat "$Date")"
	#folder exists for app
	if [ ! -d "$PWD/screenshots_$appName" ]
	then
		mkdir "$PWD/screenshots_$appName"
	fi
	#does screenshot timestamp exist
	if [ ! -f "$PWD/screenshots_$appName/$Date_$ItemID.jpg" ]
	then
		curl -s -A "$Agent" "$Image" --output "$PWD/screenshots_$appName/${Date}-$ItemID.jpg"
	else
		echo "Warning: Screenshot already exists. Skipping!"
	fi
	sleep .25
done < <(echo "$SteamScreenShots" | grep "https://steamcommunity.com/sharedfiles/filedetails/" | sed -e "s/.*href=\"//" -e "s/..onclick.*//")
