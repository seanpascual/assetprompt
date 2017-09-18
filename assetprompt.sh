#!/bin/sh

#  Name Computer.sh
#
#
#  Created by Sean Pascual on 14/09/2017.
#

REPEAT=true
while ${REPEAT}; do

COMPNAME="$(osascript -e 'display dialog "Enter asset tag 4 digit number" with icon caution default answer "" buttons{"Continue"} default button "Continue"')"


COMPNAME="$(echo $COMPNAME | cut -c 41-44)"
ASSETTAG="${COMPNAME}"
COMPNAME="Beamly-$COMPNAME"

DISPLAYNAME="Are you sure you want to name this computer: $COMPNAME"

CONFIRM=$(osascript -e "display dialog \"${DISPLAYNAME}\" buttons {\"Yes\", \"No\"} default button \"No\"")

if [[ "${CONFIRM}" == "button returned:Yes" ]]; then
#echo "Setting name to ${COMPNAME}"
jamf recon -skipApps -skipFonts -skipPlugins -assetTag ${ASSETTAG}
scutil --set ComputerName $COMPNAME
scutil --set HostName $COMPNAME
scutil --set LocalHostName $COMPNAME
REPEAT=false
fi
done

exit 0
