#!/usr/bin/env bash

###############################################################################
# PREVENT PEOPLE FROM SHOOITNG THEMSELVES IN THE FOOT                         #
###############################################################################

starting_script=`basename "$0"`
if [ "$starting_script" != "freshinstall.sh" ]; then
	echo -e "\n\033[31m\aUhoh!\033[0m This script is part of freshinstall and should not be ran by itself."
	echo -e "Please launch freshinstall itself using \033[1msudo ./freshinstall.sh\033[0m"
	echo -e "\n\033[93mMy journey stops here (for now) … bye! 👋\033[0m\n"
	exit 1
fi;

###############################################################################
# XCODE                                                                       #
###############################################################################

echo -e "\n- Xcode and Xcode Command Line Tools:\n"

xcode_ok="yes"
if [ -d "/Applications/Xcode.app" ]; then
	xcode_installed="yes"
else
	xcode_installed="no"
	xcode_ok="no"
fi;

# @ref https://github.com/Homebrew/install/blob/master/install#L110
if [ ! -f "/Library/Developer/CommandLineTools/usr/bin/git" ] || [ ! -f "/usr/include/iconv.h" ]; then
	xcodetools_installed="no"
	xcode_ok="no"
else
	xcodetools_installed="yes"
fi;

if [ "$xcode_installed" == "yes" ]; then
	echo -e "  - Xcode                    \033[32mInstalled\033[0m"
else
	echo -e "  - Xcode                    \033[31mNot Installed\033[0m"
fi;

if [ "$xcodetools_installed" == "yes" ]; then
	echo -e "  - Command Line Tools       \033[32mInstalled\033[0m"
else
	echo -e "  - Command Line Tools       \033[31mNot Installed\033[0m"
fi;

if [ "$xcode_ok" == "no" ]; then
	if [ "$xcode_installed" == "no" ]; then
		echo -e "\nSorry, but Xcode needs to installed first …"
		echo "Please install it using AppStore.app, and then relaunch this script."
		# open "/Applications/App Store.app"
		echo -e "\n\033[93mMy journey stops here (for now) … bye! 👋\033[0m\n"
		exit
	else
		if [ "$xcodetools_installed" == "no" ]; then
			echo -e "\Launching installer for Xcode Command Line Tools …"

			xcode-select --install &>/dev/null

			echo -e "\nPress any key when the installer has finished."
			read -n 1

		fi;
	fi;
fi;

# Accept the Xcode/iOS license agreement
sudo xcodebuild -license accept

###############################################################################
# HOMEBREW                                                                    #
###############################################################################

echo -e "\n- Homebrew:"

echo -ne "\n  - Installation Status      "
if [ -n "$(which brew)" ]; then
	echo -e "\033[32mInstalled\033[0m"
else
	echo -e "\033[93mInstalling\033[0m"
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	brew update
fi;

# Make sure proper permissions are set …
echo -ne "  - Folder permissions       "
if [ "$(ls -ld /usr/local/Cellar/ | awk '{print $3}')" != "$(whoami)" ]; then
	echo -e "\033[93mFixing\033[0m"
	sudo chown -R $(whoami) /usr/local/Cellar
	sudo chown -R $(whoami) /usr/local/Homebrew
	sudo chown -R $(whoami) /usr/local/var/homebrew/locks
	sudo chown -R $(whoami) /usr/local/etc /usr/local/lib /usr/local/sbin /usr/local/share /usr/local/var /usr/local/Frameworks /usr/local/share/locale /usr/local/share/man /usr/local/opt
else
	echo -e "\033[32mOK\033[0m"
fi;

# Run brew doctor to be sure
echo -ne "  - Check with “brew doctor” "

if [ "$(brew doctor 2>&1 | grep "Error")" ]; then
	echo -e "\033[31mNOK\033[0m"
	echo -e "\n\033[93mUh oh, “brew doctor” returned some errors … please fix these manually and then restart ./freshinstall\033[0m\n"
	exit
else
	echo -e "\033[32mOK\033[0m"
fi;

# Brew Cask FTW!
echo -ne "  - Brew Cask                "
brew tap caskroom/cask 2>&1 > /dev/null
brew tap caskroom/versions 2>&1 > /dev/null

if [ "$(brew cask --version 2>&1 | grep "Homebrew-Cask")" ]; then
	echo -e "\033[32mOK\033[0m"
else
	echo -e "\033[31mNOK\033[0m"
	echo -e "\n\033[93mUh oh, installation of Brew Cask failed … please try running the following commands manually and see what goes wrong.\nIf all is OK afterwards, then restart ./freshinstall\033[0m\n"
	echo -e " - brew tap caskroom/cask"
	echo -e " - brew tap caskroom/versions"
	exit
fi;

###############################################################################
# GIT                                                                         #
###############################################################################

echo -e "\n- Git: "

echo -ne "\n  - Installation Status      "

GIT_NEEDS_TO_BE_INSTALLED="no"
if [ -n "$(which git)" ]; then
	if [ ! -n "$(git --version) | grep "Apple"" ]; then # we don't want the Apple version
		echo -e "\033[33mNeeds upgrade\033[0m"
		GIT_NEEDS_TO_BE_INSTALLED="yes"
	else
		echo -e "\033[32mInstalled\033[0m"	
	fi;
else
	echo -e "\033[31mNot Installed\033[0m"
	GIT_NEEDS_TO_BE_INSTALLED="yes"
fi;

if [ "$GIT_NEEDS_TO_BE_INSTALLED" = "yes" ]; then
	brew install git
fi;

echo -e "  - Setting up your Git Identity …"

# Fall back to the Apple ID as the git e-mail address if none set yet
if [ -z "$(git config --global user.email)" ]; then
	if [ -n "$(defaults read NSGlobalDomain AppleID 2>&1 | grep -E "( does not exist)$")" ]; then
		EMAIL_ADDRESS=""
	else
		EMAIL_ADDRESS="$(defaults read NSGlobalDomain AppleID)"
	fi;
else
	EMAIL_ADDRESS="$(git config --global user.email)"
fi;
echo -e "\n    What's the e-mail address to use with Git? (default: $EMAIL_ADDRESS)"
echo -ne "    > \033[34m\a"
read
echo -e "\033[0m\033[1A\n"
[ -n "$REPLY" ] && EMAIL_ADDRESS=$REPLY

git config --global user.email "$EMAIL_ADDRESS"

# Suggest the username as git user name
if [ -z "$(git config --global user.name)" ]; then
	USERNAME="$(whoami)"
else
	USERNAME="$(git config --global user.name)"
fi;
echo -e "    What's the username to use with Git? (default: $USERNAME)"
echo -ne "    > \033[34m\a"
read
echo -e "\033[0m\033[1A\n"
[ -n "$REPLY" ] && USERNAME=$REPLY

git config --global user.name "$USERNAME"

echo -ne "  - Configuring Git        "

git config --global color.ui true

# @ref https://www.bram.us/2013/12/17/making-git-rebase-safe-on-os-x/
git config --global core.trustctime false

git config --global alias.lg "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
git config --global alias.hide "update-index --assume-unchanged"
git config --global alias.unhide "update-index --no-assume-unchanged"

echo -e "\033[32mOK\033[0m"

echo -e "\n\033[93mGreat, we've installed some essentials\033[0m"
