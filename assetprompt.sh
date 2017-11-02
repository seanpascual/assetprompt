#!/bin/sh

#  Name Computer.sh
#
#
#  Created by Sean Pascual on 14/09/2017.
#  Modified by Sean Pascual on 01/11/2017.
#

# VARIABLES OF DEPTS TO BE HIDDEN FROM USER
DEPT1="_LOST/STOLEN"
DEPT2="_OUTFORREPAIR"
DEPT3="_SPARE"
NOOFDEPTSTOREMOVE="3" #Set this to the number of departments to be hidden from the user

# SET NAME OF COMPUTER
REPEAT=true
while ${REPEAT}; do

COMPNAME="$(osascript -e 'display dialog "Enter the 4 digit number from the silver sticker on the underside of your laptop" with icon caution default answer "" buttons{"Continue"} default button "Continue"')"


COMPNAME="$(echo $COMPNAME | cut -c 41-44)"
ASSETTAG="${COMPNAME}"
COMPNAME="Beamly-$COMPNAME"

DISPLAYNAME="Are you sure you want to name this computer: $COMPNAME"

CONFIRM=$(osascript -e "display dialog \"${DISPLAYNAME}\" buttons {\"Yes\", \"No\"} default button \"No\"")

if [[ "${CONFIRM}" == "button returned:Yes" ]]; then
REPEAT=false

fi
done

# SET DEPARTMENT FOR COMPUTER
DEPTNAME="false"

############################## CURL TEST VIA JAMF API ####################

DEPTS=$(curl -H "Accept: application/json" -u sean.pascual https://beamly.tramscloud.co.uk/JSSResource/departments | sed -e 's/[{}]/''/g' |  awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | grep "name" | while read line; do cut -c 8- | sed 's/]//g'; done)
COUNTER=1
CHECK=$((${NOOFDEPTSTOREMOVE}+1))
DEPTCOUNTER="DEPT${COUNTER}"

while [${COUNTER} -lt ${CHECK}]; do
DEPTS=$(sed -i '' '${!DEPTCOUNTER}/d')
COUNTER=$((${COUNTER}+1))
CHECK=$((${CHECK}+1))
done


##########################################################################



while [ ${DEPTNAME} == "false" ]; do
DEPTNAME="$(osascript -e 'set deptList to {"Campaigns", "Consumer Experience", "Creative", "Engineering", "Marketing Science", "Operations and Management", "Product"}' -e 'choose from list deptList with prompt "Select the department this computer will belong to"')"
done

# SET FULL NAME OF USER OF COMPUTER
FULLNAME=""
while [ "${FULLNAME}" == "" ]; do
FULLNAME="$(osascript -e 'display dialog "Enter the first name and surname of the user of this computer" default answer "" buttons{"Continue"} default button "Continue"')"
FULLNAME="$(echo ${FULLNAME} | cut -c 41-)"
done

# SET EMAIL ADDRESS OF USER OF COMPUTER
EMAIL=""
while [ "${EMAIL}" == "" ]; do
EMAIL="$(osascript -e 'display dialog "Enter the email address of the user of this computer" default answer "" buttons{"Continue"} default button "Continue"')"
EMAIL="$(echo ${EMAIL}  | cut -c 41-)"
done

#echo "Setting name to ${COMPNAME}"
scutil --set ComputerName $COMPNAME
scutil --set HostName $COMPNAME
scutil --set LocalHostName $COMPNAME
jamf recon -skipApps -skipFonts -skipPlugins -assetTag "${ASSETTAG}" -department "${DEPTNAME}" -realname "${FULLNAME}" -email "${EMAIL}"

exit 0
