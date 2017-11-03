#!/bin/sh

#  Name Computer.sh
#
#
#  Created by Sean Pascual on 14/09/2017.
#  Modified by Sean Pascual on 03/11/2017.
#

# DEPARTMENTS TO BE HIDDEN FROM USER - EDIT AS NECESSARY
declare -a DEPTSTOREMOVE=('_LOST/STOLEN' '_OUTFORREPAIR' '_SPARE')

user='ls -la /dev/console | cut -d " " -f 4'

USERNAME="$4"
PASS="$7"
JSSPATH="$8"

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

### SET DEPARTMENT FOR COMPUTER

# CURL DEPARTMENT LIST FROM THE JSS
DEPTS=$(curl -H "Accept: application/json" -u $USERNAME:$PASS $JSSPATH/departments | sed -e 's/[{}]/''/g' |  awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | grep "name" | while read line; do cut -c 8- | sed 's/]//g'; done)
sleep 3

# ITERATE THROUGH AND REMOVE DEPARTMENTS TO NOT SHOW TO USER FROM 'DEPTSTOREMOVE' VAR ABOVE
for i in ${DEPTSTOREMOVE[@]}; do
DEPTS=$(echo "${DEPTS}" | grep -v "${i}")
done

# CHANGE DEPT DATA TO SOMETHING APPLESCRIPT CAN READ
DEPTS=$(echo ${DEPTS} | sed 's/" "/", "/g')

#while [ ${DEPTNAME} == "false" ]; do
#DEPTNAME="$(osascript -e 'set deptList to {${DEPTS}' -e 'choose from list deptList with prompt "Select the department this computer will belong to"')"
#done

# DISPLAY DIALOG TO USER TO CHOOSE THEIR DEPARTMENT
DEPTNAME="false"

while [ ${DEPTNAME} == "false" ]; do
DEPTNAME=$(/usr/bin/osascript << EOF
set deptList to {$DEPTS}
choose from list deptList with prompt "Select the department this computer will belong to"
EOF)
echo ${DEPTNAME}
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
