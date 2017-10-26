#!/bin/sh

#  Name Computer.sh
#
#
#  Created by Sean Pascual on 14/09/2017.
#  Modified by Sean Pascual on 26/10/2017.
#

# SET NAME OF COMPUTER
REPEAT=true
while ${REPEAT}; do

COMPNAME="$(osascript -e 'display dialog "Enter the 4 digit number from the silver sticker on the underside of your laptop" with icon caution default answer "" buttons{"Continue"} default button "Continue"')"


COMPNAME="$(echo $COMPNAME | cut -c 41-44)"
ASSETTAG="${COMPNAME}"
COMPNAME="Beamly-$COMPNAME"

DISPLAYNAME="Are you sure you want to name this computer: $COMPNAME"

CONFIRM=$(osascript -e "display dialog \"${DISPLAYNAME}\" buttons {\"Yes\", \"No\"} default button \"No\"")

# SET DEPARTMENT FOR COMPUTER
if [[ "${CONFIRM}" == "button returned:Yes" ]]; then

while [ ${DEPTNAME} == "false" ]; do
DEPTNAME="$(osascript -e 'set deptList to {"IT", "Engineering"}' -e 'choose from list deptList with prompt "Select the department this computer will belong to"')"
done

fi
done

# SET FULL NAME OF USER OF COMPUTER
FULLNAME="$(osascript -e 'display dialog "Enter the first name and surname of the user of this computer" default answer "" buttons{"Continue"} default button "Continue"')"

# SET EMAIL ADDRESS OF USER OF COMPUTER
EMAIL="$(osascript -e 'display dialog "Enter the email address of the user of this computer" default answer "" buttons{"Continue"} default button "Continue"')"

#echo "Setting name to ${COMPNAME}"
scutil --set ComputerName $COMPNAME
scutil --set HostName $COMPNAME
scutil --set LocalHostName $COMPNAME
jamf recon -skipApps -skipFonts -skipPlugins -assetTag ${ASSETTAG} -department ${DEPTNAME} -realname ${FULLNAME} -email ${EMAIL}
REPEAT=false

exit 0
