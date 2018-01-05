#!/usr/bin/env bash

###############################################################################
# UTILS                                                                       #
###############################################################################

function showheader {
	# Clear the screen
	# echo -e "\033[0m\033[2J"
	echo -ne "\033c"

	# Such banner, much amaze, wow
	COLUMNS=$(tput cols)
	SPACES_TO_CENTER=$(printf "%*s\n" $((($COLUMNS-144)/2)))
	echo -e "\033[48;5;242m$SPACES_TO_CENTER###############################################################################################################################################$SPACES_TO_CENTER "
	echo -e "\033[48;5;241m$SPACES_TO_CENTER#                                                                                                                                             #$SPACES_TO_CENTER "
	echo -e "\033[48;5;240m$SPACES_TO_CENTER#   :::::::::: :::::::::  ::::::::::  ::::::::  :::    ::: ::::::::::: ::::    :::  ::::::::  :::::::::::     :::     :::        :::          #$SPACES_TO_CENTER "
	echo -e "\033[48;5;239m$SPACES_TO_CENTER#   :+:        :+:    :+: :+:        :+:    :+: :+:    :+:     :+:     :+:+:   :+: :+:    :+:     :+:       :+: :+:   :+:        :+:          #$SPACES_TO_CENTER "
	echo -e "\033[48;5;238m$SPACES_TO_CENTER#   +:+        +:+    +:+ +:+        +:+        +:+    +:+     +:+     :+:+:+  +:+ +:+            +:+      +:+   +:+  +:+        +:+          #$SPACES_TO_CENTER "
	echo -e "\033[48;5;237m$SPACES_TO_CENTER#   :#::+::#   +#++:++#:  +#++:++#   +#++:++#++ +#++:++#++     +#+     +#+ +:+ +#+ +#++:++#++     +#+     +#++:++#++: +#+        +#+          #$SPACES_TO_CENTER "
	echo -e "\033[48;5;236m$SPACES_TO_CENTER#   +#+        +#+    +#+ +#+               +#+ +#+    +#+     +#+     +#+  +#+#+#        +#+     +#+     +#+     +#+ +#+        +#+          #$SPACES_TO_CENTER "
	echo -e "\033[48;5;235m$SPACES_TO_CENTER#   #+#        #+#    #+# #+#        #+#    #+# #+#    #+#     #+#     #+#   #+#+# #+#    #+#     #+#     #+#     #+# #+#        #+#          #$SPACES_TO_CENTER "
	echo -e "\033[48;5;234m$SPACES_TO_CENTER#   ###        ###    ### ##########  ########  ###    ### ########### ###    ####  ########      ###     ###     ### ########## ##########   #$SPACES_TO_CENTER "
	echo -e "\033[48;5;233m$SPACES_TO_CENTER#                                                                                                                                             #$SPACES_TO_CENTER "
	echo -e "\033[48;5;232m$SPACES_TO_CENTER###############################################################################################################################################$SPACES_TO_CENTER \033[0m\n\n\n"
}

function askforreboot {
	echo -e "\n\033[36mA reboot is required. After rebooting re-run this script, it will continue right where it left so no worries there 😊\033[0m"
	echo -e "\nDo you want to reboot now? [Y/n]"
	echo -ne "> \033[94m\a"
	read -r
	echo -e "\033[0m"

	if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
		echo -e "\n\033[93mRebooting now. See you on the other side …\033[0m\n"
		# sudo shutdown -r now
		osascript -e 'tell app "System Events" to restart'
		exit;
	fi;
}

function askforrestart {
	echo -e "\n\033[36mA restart of Terminal is required. After restarting Terminal re-run this script, it will continue right where it left so no worries there 😊\033[0m"
	echo -e "\nDo you want to exit Terminal now? [Y/n]"
	echo -ne "> \033[94m\a"
	read -r
	echo -e "\033[0m"

	if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
		echo -e "\n\033[93mRestarting Terminal. See you on the other side …\033[0m\n"
		killall "Terminal" &> /dev/null
		exit;
	fi;
}

function pressanykeytocontinue {
	echo -e "\nPress any key to continue …"
	read -n 1
}

function checksudoandprompt {
	if [ -n "$(sudo -nl 2>&1 | grep -E "password is required$")" ]; then
		echo -ne "\a"
		sudo -v
	else
		echo -e "\n\033[93mAlready running with sudo pass … no need to ask 😊\033[0m"
	fi;
}

function checksudoandexit {
	if [ -n "$(sudo -nl 2>&1 | grep -E "password is required$")" ]; then
		echo -e "\n\033[31m\aUhoh!\033[0m Withyout a sudo pass freshinstall can't do much …"
		echo -e "Please relaunch freshinstall using \033[1m./freshinstall.sh\033[0m"
    	echo -e "\n\033[93mMy journey stops here (for now) … bye! 👋\033[0m\n"
		exit 1
	fi;
}

###############################################################################
# WELCOME!                                                                    #
###############################################################################

showheader

# Prevent from running this script via `sudo ./freshinstall`
if [[ $EUID == 0 ]]; then
    echo -e "\n\033[31m\aUhoh!\033[0m It looks like you're running this script using sudo. Please don't, as that will fuck things up."
    echo -e "Please relaunch freshinstall using \033[1m./freshinstall.sh\033[0m"
    echo -e "\n\033[93mMy journey stops here (for now) … bye! 👋\033[0m\n"
    exit 1
fi;

# Some info
echo ""
echo "So you want to set up a new Mac aye? Good, freshinstall will help you out with that."
echo "Beware though … it will alter many of your settings … know what you are doing!"

# Allow --force to start all over again
if [ "$1" == "--force" -o "$1" == "-f" ]; then
	echo -e "\n\033[93mOption --force used, let's start all over again …\033[0m"
	if [ -z "$(defaults read us.bram.freshinstall step 2>&1 | grep -E "( does not exist)$")" ]; then
		defaults delete us.bram.freshinstall step
	fi;
fi;

if [ -n "$(defaults read us.bram.freshinstall step 2>&1 | grep -E "( does not exist)$")" ]; then
	lastsuccessfullstep=0
else
	echo -e "\n\033[36m… resuming from where we left off\033[0m"
	lastsuccessfullstep="$(defaults read us.bram.freshinstall step)"
fi;

###############################################################################
# STEP 0a: SUDO                                                               #
###############################################################################

echo -e "\nSince freshinstall will be altering your computer settings, it's gonna need sudo privileges. Please enter your password"
checksudoandprompt

checksudoandexit

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###############################################################################
# STEP 0b: ASK USER IF THEY'RE REALLY, REALLY, REALLY SURE                    #
###############################################################################

if [ "$lastsuccessfullstep" -eq "0" ]; then
	echo -e "\nIf you're really sure you want to continue, enter “freshinstall” to continue"
	echo -ne "> \033[94m\a"
	read
	echo -e "\033[0m\033[1A"

	if [[ $REPLY != "freshinstall" ]]; then
		echo -e "\n\033[93mNo worries, I'll stop here … Ciao! 👋\033[0m\n"
		exit 0
	fi;

	echo -e "\n\033[93mOK, you asked for it … let's a go!\033[0m"

	pressanykeytocontinue
fi;

###############################################################################
# STEP 1: MACOS DEFAULTS                                                      #
###############################################################################

if [ "$lastsuccessfullstep" -lt "1" ]; then
	showheader
	echo -e "\n\033[4m\033[1mStep 1: macOS settings\033[0m"
	source ./steps/1.macos-settings.sh
	defaults write us.bram.freshinstall step 1
	askforreboot
fi;

###############################################################################
# STEP 2: SSH                                                                 #
###############################################################################

if [ "$lastsuccessfullstep" -lt "2" ]; then
	showheader
	echo -e "\n\033[4m\033[1mStep 2: SSH\033[0m"
	source ./steps/2.ssh.sh
	defaults write us.bram.freshinstall step 2
	pressanykeytocontinue
fi;

###############################################################################
# STEP 3: ESSENTIALS                                                          #
###############################################################################

if [ "$lastsuccessfullstep" -lt "3" ]; then
	showheader
	echo -e "\n\033[4m\033[1mStep 3: Essentials\033[0m"
	source ./steps/3.essentials.sh
	defaults write us.bram.freshinstall step 3
	pressanykeytocontinue
fi;

###############################################################################
# STEP 4: DOTFILES                                                            #
###############################################################################

if [ "$lastsuccessfullstep" -lt "4" ]; then
	showheader
	echo -e "\n\033[4m\033[1mStep 4: Dotfiles\033[0m"
	source ./steps/4.dotfiles.sh
	defaults write us.bram.freshinstall step 4
	askforrestart
fi;

###############################################################################
# STEP 5: SOFTWARE                                                            #
###############################################################################

if [ "$lastsuccessfullstep" -lt "5" ]; then
	showheader
	echo -e "\n\033[4m\033[1mStep 5: Software\033[0m"
	source ./steps/5.software.sh
	defaults write us.bram.freshinstall step 5
	pressanykeytocontinue
fi;

###############################################################################
# ALL.DONE                                                                    #
###############################################################################

echo -e "\n\033[32mYay, we're all done here! 🎉\nEnjoy your freshly installed computer! 😊\033[0m\n"
exit
