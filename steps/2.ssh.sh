#!/usr/bin/env bash

###############################################################################
# PREVENT PEOPLE FROM SHOOITNG THEMSELVES IN THE FOOT                         #
###############################################################################

starting_script=`basename "$0"`
if [ "$starting_script" != "freshinstall.sh" ]; then
	echo -e "\n\033[31m\aUhoh!\033[0m This script is part of freshinstall and should not be ran by itself."
	echo -e "Please launch freshinstall itself using \033[1m./freshinstall.sh\033[0m"
	echo -e "\n\033[93mMy journey stops here (for now) … bye! 👋\033[0m\n"
	exit 1
fi;

###############################################################################
# CONFIG                                                                      #
###############################################################################

SSH_DIR=~/.ssh

###############################################################################
# HOUSEKEEPING                                                                #
###############################################################################

echo -ne "\n- Checking $SSH_DIR for existence: "

if [ "$(ls $SSH_DIR 2>&1 | grep "No such file or directory")" ]; then
	ssh_dir_present="no"
else
	ssh_dir_present="yes"
fi;

if [ "$ssh_dir_present" == "yes" ]; then
	echo -e "\033[32mOK\033[0m"
else
	mkdir "$SSH_DIR"
	echo -e "\033[93mCREATED\033[0m"
fi;

###############################################################################
# CONFIG FILE                                                                 #
###############################################################################

echo -ne "- Checking $SSH_DIR/config for existence: "

if [ "$(cat $SSH_DIR/config 2>&1 | grep "No such file or directory")" ]; then
	config_file_present="no"
else
	config_file_present="yes"
fi;

if [ "$config_file_present" == "yes" ]; then
	echo -e "\033[32mOK\033[0m"
	# @TODO: Check for “Host *: UseKeychain yes”
else
	touch $SSH_DIR/config
	echo "Host *" >> $SSH_DIR/config
	echo "	AddKeysToAgent yes" >> $SSH_DIR/config
	echo "	UseKeychain yes" >> $SSH_DIR/config
	echo "" >> $SSH_DIR/config
	echo -e "\033[93mCREATED\033[0m"
fi;

###############################################################################
# SSH KEYS                                                                    #
###############################################################################

echo -ne "- Detecting SSH keys in $SSH_DIR/: "

if [ "$(ls -a $SSH_DIR/*.pub 2>&1 | sort | grep "No such file or directory")" ]; then
	ssh_key_detected="no"
else
	ssh_key_detected="yes"
fi;

if [ "$ssh_key_detected" == "yes" ]; then
	echo -e "\033[32mOne or more detected\033[0m\n"
	for file in "$(ls -a $SSH_DIR/*.pub)"; do

		echo -e "  - \033[4m$file\033[0m\n"

		FINGERPRINT="$(ssh-keygen -lf $file)"
		FINGERPRINT_MD5="$(ssh-keygen -E md5 -lf $file)"
		echo -e "    Fingerprint:              $FINGERPRINT"
		echo -e "    Fingerprint (md5):        $FINGERPRINT_MD5"

		echo -ne "    Status:                   "
		if [ "$(ssh-add -l | grep "${file/.pub/}")" ]; then
			echo -e "\033[32mLoaded in ssh-agent\033[0m\n"
		else
			echo -e "\033[31mNot loaded in ssh-agent\033[0m\n"

			echo -e "    Do you want me to add this key to ssh-agent? [Y/n]"
			echo -ne "    > \033[94m\a"
			read -r
			echo -e "\033[0m\n"

			if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
				echo -ne "    Adding ssh-key “${file/.pub/}” to ssh-agent: "
				ADDED="$(ssh-add -K "${file/.pub/}" 2>&1 | grep "Identity added")"
				if [ "$ADDED" ]; then
					echo -e "\033[32mOK\033[0m\n"
				else
					echo -e "\033[31mNOK\033[0m\n"
				fi;
			fi;

		fi;
	done
else

	echo -e "\033[93mCREATING\033[0m\n"

	# Suggest the Apple ID as the e-mail address to use for SSH key generation
	if [ -n "$(defaults read NSGlobalDomain AppleID 2>&1 | grep -E "( does not exist)$")" ]; then
		EMAIL_ADDRESS=""
	else
		EMAIL_ADDRESS="$(defaults read NSGlobalDomain AppleID)"
	fi;
	echo -e "What's your e-mail address to use with your SSH key? (default: $EMAIL_ADDRESS)"
	echo -ne "> \033[34m\a"
	read
	echo -e "\033[0m\033[1A\n"
	[ -n "$REPLY" ] && EMAIL_ADDRESS=$REPLY

	ssh-keygen -t rsa -b 4096 -C "$EMAIL_ADDRESS" -f "$SSH_DIR/id_rsa"

	echo -e "\n\033[93mCREATED “$SSH_DIR/id_rsa”\033[0m\n"

	echo -e "Do you want me to add this newly generated key to ssh-agent? [Y/n]"
	echo -ne "> \033[94m\a"
	read -r
	echo -e "\033[0m"

	if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
		echo -ne "Adding ssh-key “$SSH_DIR/id_rsa” to ssh-agent: "
		ADDED="$(ssh-add -K "$SSH_DIR/id_rsa" 2>&1 | grep "Identity added")"
		if [ "$ADDED" ]; then
			echo -e "\033[32mOK\033[0m\n"
		else
			echo -e "\033[31mNOK\033[0m\n"
		fi;
	fi;

fi;

echo -e "\n\033[93mGreat, SSH is now configured! Don't forget to add your public SSH key to any services and servers you're using.\033[0m"

for file in "$(ls -a $SSH_DIR/*.pub)"; do cat $file; done;
