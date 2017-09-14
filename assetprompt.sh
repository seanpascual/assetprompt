#!/bin/sh

#  assetprompt.sh
#  
#
#  Created by Sean Pascual on 14/09/2017.
#

MYDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pashLoc="Pashua.app"

###########################################################################
# SHORTCUTS
######################################################################
#cdPath="cocoaDialog.app/Contents/MacOS/cocoaDialog"
source "$MYDIR/pashua.sh"


##########################
# Create the GUI
conf="
# Set window title
*.title = macOS Config Tool

# Get the icon from the application bundle
img.type = image
img.tooltip = This is an element of type “image”
img.path = "$MYDIR/beamly-logo-pink.png"

# Introductory text
txt.type = text
txt.default = To setup this computer, please enter the following information.
txt.width = 310

# Add a text field
compname.type = textfield
compname.label = 4 digit asset tag [from the bottom of the computer]
compname.width = 100

db.type = defaultbutton
"


pashua_run "$conf" "$pashLoc"


##########################
# Prompt for the name of the computer and name it
compname = "Beamly-$compname"

scutil --set ComputerName $compname
scutil --set HostName $compname
scutil --set LocalHostName $compname


##########################
# Tell user that the installation is complete
exit 0
