#!/usr/bin/env bash

###############################################################################
# PREVENT PEOPLE FROM SHOOTING THEMSELVES IN THE FOOT                         #
###############################################################################

starting_script=`basename "$0"`
if [ "$starting_script" != "freshinstall.sh" ]; then
	echo -e "\n\033[31m\aUhoh!\033[0m This script is part of freshinstall and should not be run by itself."
	echo -e "Please launch freshinstall itself using \033[1m./freshinstall.sh\033[0m"
	echo -e "\n\033[93mMy journey stops here (for now) … bye! 👋\033[0m\n"
	exit 1
fi;

DOIT="no"
if [ -f ~/.zshrc ]; then
	echo -e "\nA ~/.zshrc (and other files) already exists and will be overwritten.\nEnter “overwrite” to continue, or just hit enter to skip this step."
	echo -ne "> \033[94m\a"
	read
	echo -e "\033[0m\033[1A"

	if [[ "$REPLY" == "overwrite" ]]; then
		DOIT="yes"
	else
		DOIT="no"
	fi;
else
	DOIT="yes"
fi;

###############################################################################
# CORE                                                                        #
###############################################################################

if [[ "$DOIT" == "yes" ]]; then
	echo -e "\n\033[93mOK, I'll overwrite the files for you 😱\033[0m"
	echo -ne "\n- Copying dotfiles to their destination: "
	# Dependencies for .zshrc
	curl -L git.io/antigen > ~/antigen.zsh
	brew install zsh-completions
	# The actual copying
	cp -R ./resources/dotfiles/ ~/
	echo -e "\033[32mDone\033[0m"

	echo -ne "\n- Loading the global .gitignore: "
	git config --global core.excludesfile ~/.gitignore
	echo -e "\033[32mDone\033[0m"

	echo -e "\n\033[93mGreat, the dotfiles have been put in place!\033[0m"
else
	echo -e "\n\033[93mAllrighty, I'll skip this step 😉\033[0m"
fi;
