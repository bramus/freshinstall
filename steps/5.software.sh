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


###############################################################################
# Sublime Text                                                                #
###############################################################################

brew install --cask sublime-text

# Make sure directories exists
if [ ! -d "~/Library/Application Support/Sublime Text 3" ]; then
	mkdir ~/Library/Application\ Support/Sublime\ Text\ 3
fi;
if [ ! -d "~/Library/Application Support/Sublime Text 3/Installed Packages" ]; then
	mkdir ~/Library/Application\ Support/Sublime\ Text\ 3/Installed\ Packages
fi;
if [ ! -d "~/Library/Application Support/Sublime Text 3/Packages" ]; then
	mkdir ~/Library/Application\ Support/Sublime\ Text\ 3/Packages
fi;
if [ ! -d "~/Library/Application Support/Sublime Text 3/Packages/User" ]; then
	mkdir ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User
fi;

# Install Package Control
# @ref https://github.com/joeyhoer/starter/blob/master/apps/sublime-text.sh
cd ~/Library/Application\ Support/Sublime\ Text\ 3/Installed\ Packages && { curl -sLO https://packagecontrol.io/Package\ Control.sublime-package ; cd -; }

# Install Plugins and Config
cp -r ./resources/apps/sublime-text/* ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User/ 2>/dev/null

# Open files by default with sublime using duti
#
# Note that duti is preferred over the command below, as that on requires a reboot
# 	defaults write com.apple.LaunchServices LSHandlers -array-add '{"LSHandlerContentType" = "public.plain-text"; "LSHandlerPreferredVersions" = { "LSHandlerRoleAll" = "-"; }; LSHandlerRoleAll = "com.sublimetext.3";}'
#
# Some pointers:
# - To get identifier of Sublime: /usr/libexec/PlistBuddy -c 'Print CFBundleIdentifier' /Applications/Sublime\ Text.app/Contents/Info.plist
# - To get UTI of a file: mdls -name kMDItemContentTypeTree /path/to/file.ext
#
brew install duti
duti -s com.sublimetext.3 public.data all # for files like ~/.bash_profile
duti -s com.sublimetext.3 public.plain-text all
duti -s com.sublimetext.3 public.script all
duti -s com.sublimetext.3 net.daringfireball.markdown all


###############################################################################
# vim                                                                         #
###############################################################################

cp ./resources/apps/vim/.vimrc ~/.vimrc


###############################################################################
# git-ftp (for older projects)                                                #
###############################################################################

sudo chown -R $(whoami):staff /Library/Python/2.7
curl https://bootstrap.pypa.io/get-pip.py | python
pip install gitpython

cp ./resources/apps/git-ftp/git-ftp.py ~/git-ftp.py
echo '# git-ftp' >> ~/.bash_profile
echo 'alias git-ftp="python ~/git-ftp.py"' >> ~/.bash_profile


###############################################################################
# CLOUD COMPUTE SHIZZLE                                                       #
###############################################################################

curl https://sdk.cloud.google.com | bash
# Run this to configure: gcloud init
pip3 install awscli --upgrade --user

# Google Cloud Platform: Cloud SQL Proxy
curl -o cloud_sql_proxy https://dl.google.com/cloudsql/cloud_sql_proxy.darwin.amd64
chmod +x cloud_sql_proxy
mv cloud_sql_proxy /usr/local/bin/cloud_sql_proxy


###############################################################################
# NVM + Node Versions                                                         #
###############################################################################

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
source ~/.bash_profile

nvm install 7
nvm install 9
nvm use default 9

NPM_USER=""
echo -e "\nWhat's your NPMJS username?"
echo -ne "> \033[34m\a"
read
echo -e "\033[0m\033[1A\n"
[ -n "$REPLY" ] && NPM_USER=$REPLY

if [ "$NPM_USER" != "" ]; then
	npm adduser $NPM_USER
fi;


###############################################################################
# Node based tools                                                            #
###############################################################################

npm i -g node-notifier-cli


###############################################################################
# RVM                                                                         #
###############################################################################

curl -sSL https://get.rvm.io | bash -s stable --ruby
source ~/.profile


###############################################################################
# Mac App Store                                                               #
###############################################################################

brew install mas

# Apple ID
if [ -n "$(defaults read NSGlobalDomain AppleID 2>&1 | grep -E "( does not exist)$")" ]; then
	AppleID=""
else
	AppleID="$(defaults read NSGlobalDomain AppleID)"
fi;
echo -e "\nWhat's your Apple ID? (default: $AppleID)"
echo -ne "> \033[34m\a"
read
echo -e "\033[0m\033[1A\n"
[ -n "$REPLY" ] && AppleID=$REPLY

if [ "$AppleID" != "" ]; then

	# Sign in
	mas signin $AppleID

	# Tweetbot + config
	mas install 1384080005 # Tweetbot

	# iWork
	mas install 409203825 # Numbers
	mas install 409201541 # Pages
	mas install 409183694 # Keynote

	# Others
	mas install 494803304 # Wifi Explorer
	mas install 425424353 # The Unarchiver
	mas install 404167149 # IP Scanner
	mas install 402397683 # MindNode Lite
	mas install 578078659 # ScreenSharingMenulet
	mas install 803453959 # Slack
	mas install 1006739057 # NepTunes (Last.fm Scrobbling)
	mas install 955297617 # CodeRunner 2
	mas install 1313773050 # Artstudio Pro
	mas install 824171161 # Affinity Designer
	mas install 824183456 # Affinity Photo
	mas install 411643860 # DaisyDisk
	mas install 1392471092 # NFC Tools for Desktop
	mas install 1019371109 # Balance Lock
	mas install 1470584107 # Dato

fi;


###############################################################################
# TMUX                                                                        #
###############################################################################

brew install tmux
brew install reattach-to-user-namespace
cp ./resources/apps/tmux/.tmux.conf ~/.tmux.conf


###############################################################################
# BROWSERS                                                                    #
###############################################################################

brew install --cask firefox
brew install --cask firefoxdeveloperedition
brew install --cask google-chrome
brew install --cask google-chrome-canary
brew install --cask safari-technology-preview


###############################################################################
# IMAGE & VIDEO PROCESSING                                                    #
###############################################################################

brew install imagemagick

brew install libvpx
brew install ffmpeg
brew install youtube-dl


###############################################################################
# VISCOSITY + CONFIGS                                                         #
###############################################################################

brew install --cask viscosity
curl -s -o ~/Downloads/ovpn_configs.zip -L https://privado.io/apps/ovpn_configs.zip > /dev/null

echo -e "\n\033[93mYou'll need to import the Viscosity configs manually. I've downloadeded them to “~/Downloads/ovpn_configs.zip” for you …\033[0m\n"


###############################################################################
# REACT NATIVE + TOOLS                                                        #
###############################################################################

npm install -g react-native-cli

brew install yarn
echo "# Yarn" >> ~/.bash_profile
echo 'export PATH="$HOME/.yarn/bin:$PATH"' >> ~/.bash_profile
source ~/.bash_profile

brew install watchman
# Watchman needs permissions on ~/Library/LaunchAgents
if [ ! -d "~/Library/LaunchAgents" ]; then
	sudo chown -R $(whoami):staff ~/Library/LaunchAgents
else
	mkdir ~/Library/LaunchAgents
fi;

brew install --cask react-native-debugger

brew install --HEAD libimobiledevice
gem install xcpretty


###############################################################################
# QUICK LOOK PLUGINS                                                          #
###############################################################################

# https://github.com/sindresorhus/quick-look-plugins
brew install --cask qlcolorcode
brew install --cask qlstephen
brew install --cask qlmarkdown
brew install --cask quicklook-json
brew install --cask qlimagesize
brew install --cask suspicious-package
brew install --cask qlvideo

brew install --cask provisionql
brew install --cask quicklookapk

# restart quicklook
defaults write org.n8gray.QLColorCode extraHLFlags '-l'
qlmanage -r
qlmanage -m


###############################################################################
# Composer + MySQL + Valet                                                    #
###############################################################################

# PHP Versions
brew install php
brew install php@7.4

brew services start php@7.4
brew link php@7.4

# pecl install mcrypt-1.0.1 # mcrypt for PHP > 7.1
pecl install grpc
pecl install protobuf

# @note: You might wanna "sudo brew services restart php" after this

# Composer
curl -s https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

echo "# Composer" >> ~/.bash_profile
echo 'export PATH="$HOME/.composer/vendor/bin:$PATH"' >> ~/.bash_profile
source ~/.bash_profile

# Composer Autocomplete
# brew install bash-completion
curl -#L https://github.com/bramus/composer-autocomplete/tarball/master | tar -xzv --strip-components 1 --exclude={LICENSE,README.md}
mv ./composer-autocomplete ~/composer-autocomplete
echo "" >> ~/.bash_profile
echo 'if [ -f "$HOME/composer-autocomplete" ] ; then' >> ~/.bash_profile
echo '    . $HOME/composer-autocomplete' >> ~/.bash_profile
echo "fi" >> ~/.bash_profile
source ~/.bash_profile

# MySQL
brew install mysql
brew services start mysql

# Tweak MySQL
mysqlpassword="root"
echo -e "\n  What should the root password for MySQL be? (default: $mysqlpassword)"
echo -ne "  > \033[34m\a"
read
echo -e "\033[0m\033[1A"
[ -n "$REPLY" ] && mysqlpassword=$REPLY

mysql -u root -e "ALTER USER root@localhost IDENTIFIED WITH mysql_native_password BY '$mysqlpassword'; FLUSH PRIVILEGES;"
cat ./resources/apps/mysql/my.cnf > /usr/local/etc/my.cnf
brew services restart mysql

# Laravel Valet
composer global require laravel/valet
valet install

# If you want PMA available over https://pma.test/, run this:
# cd ~/repos/misc/
# composer create-project phpmyadmin/phpmyadmin
# cd ~/repos/misc/phpmyadmin
# valet link pma
# valet secure

###############################################################################
# Transmission.app + Config                                                   #
###############################################################################

# Install it
brew install --cask transmission

# Use `~/Downloads/_INCOMING` to store incomplete downloads
defaults write org.m0k.transmission UseIncompleteDownloadFolder -bool true
defaults write org.m0k.transmission IncompleteDownloadFolder -string "${HOME}/Downloads/_INCOMING"
if [ ! -d "${HOME}/Downloads/_INCOMING" ]; then
	mkdir ${HOME}/Downloads/_INCOMING
fi;

# Use `~/Downloads/_COMPLETE` to store completed downloads
defaults write org.m0k.transmission DownloadLocationConstant -bool true
defaults write org.m0k.transmission DownloadFolder -string "${HOME}/Downloads/_COMPLETE"
if [ ! -d "${HOME}/Downloads/_COMPLETE" ]; then
	mkdir ${HOME}/Downloads/_COMPLETE
fi;

# Autoload torrents from Downloads folder
defaults write org.m0k.transmission AutoImportDirectory -string "${HOME}/Downloads"

# Don’t prompt for confirmation before downloading
defaults write org.m0k.transmission DownloadAsk -bool false
defaults write org.m0k.transmission MagnetOpenAsk -bool false

# Don’t prompt for confirmation before removing non-downloading active transfers
defaults write org.m0k.transmission CheckRemoveDownloading -bool true

# Trash original torrent files
defaults write org.m0k.transmission DeleteOriginalTorrent -bool true

# Hide the donate message
defaults write org.m0k.transmission WarningDonate -bool false
# Hide the legal disclaimer
defaults write org.m0k.transmission WarningLegal -bool false

# IP block list.
# Source: https://giuliomac.wordpress.com/2014/02/19/best-blocklist-for-transmission/
defaults write org.m0k.transmission BlocklistNew -bool true
defaults write org.m0k.transmission BlocklistURL -string "http://john.bitsurge.net/public/biglist.p2p.gz"
defaults write org.m0k.transmission BlocklistAutoUpdate -bool true

# Randomize port on launch
# defaults write org.m0k.transmission RandomPort -bool true

# Set UploadLimit
defaults write org.m0k.transmission SpeedLimitUploadLimit -int 10
defaults write org.m0k.transmission UploadLimit -int 5

###############################################################################
# OTHER BREW/CASK THINGS                                                      #
###############################################################################

brew install tig

brew install speedtest-cli
brew install jq

brew install --cask 1password
brew install --cask macpass

brew install --cask caffeine
# brew install --cask nosleep

brew install --cask deltawalker
brew install --cask macpar-deluxe

brew install --cask vlc
duti -s org.videolan.vlc public.avi all
# brew install --cask plex-media-server

brew install --cask charles
brew install --cask ngrok

# Already installed through mas
# brew install --cask slack
brew install --cask skype
brew install --cask whatsapp

brew install --cask tower
brew install --cask dropbox
brew install --cask transmit4

brew install --cask handbrake
brew install --cask spectacle

brew install mkvtoolnix
brew install --cask makemkv
brew install --cask jubler
brew install --cask flixtools

brew install --cask the-archive-browser
brew install --cask imagealpha
brew install --cask imageoptim
brew install --cask colorpicker-skalacolor

brew install --cask steam
brew install --cask epic-games

brew install --cask xact

brew install --cask postman

brew install --cask screenflow
brew install --cask kap
brew install --cask streamlabs-obs
brew install --cask keycastr

brew install --cask subsurface
brew install --cask quik

brew install --cask veracrypt

brew install --cask elgato-stream-deck

brew install --cask little-snitch

###############################################################################
# Virtual Machines and stuff                                                  #
###############################################################################

brew install --cask vmware-fusion
brew install --cask docker

###############################################################################
# Android Studio                                                              #
###############################################################################

# @ref https://gist.github.com/agrcrobles/165ac477a9ee51198f4a870c723cd441
# @ref https://gist.github.com/spilth/e7385e7f5153f76cca40a192be35f4ba

touch ~/.android/repositories.cfg

# Android Dev Tools
brew install --cask caskroom/versions/java8 # Still Needed?
# echo 'export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk1.8.0_202.jdk/Contents/Home"' >> ~/.bash_profile
# echo 'export PATH=$JAVA_HOME/bin:$PATH' >> ~/.bash_profile
brew install ant
brew install maven
brew install gradle
# brew install qt
brew install --cask android-sdk # Still needed?
brew install --cask android-ndk # Still needed?
brew install --cask android-platform-tools

# SDK Components
sdkmanager "platform-tools" "extras;intel;Hardware_Accelerated_Execution_Manager" "emulator" # What about "build-tools;28.0.3"?
# echo y | …

# HAXM
if [ $(sw_vers -productVersion | cut -d. -f2) -lt 13 ]; then
	brew install --cask intel-haxm
else
	echo -e "\n\033[93mCould not install intel-haxm on this OS. It's not supported (yet)\033[0m\n"
fi;

# ENV Variables
echo 'export ANT_HOME=/usr/local/opt/ant' >> ~/.bash_profile
echo 'export MAVEN_HOME=/usr/local/opt/maven' >> ~/.bash_profile
echo 'export GRADLE_HOME=/usr/local/opt/gradle' >> ~/.bash_profile
echo 'export ANDROID_HOME=/usr/local/share/android-sdk' >> ~/.bash_profile
echo 'export ANDROID_SDK_ROOT="$ANDROID_HOME"' >> ~/.bash_profile
echo 'export ANDROID_AVD_HOME="$HOME/.android/avd"' >> ~/.bash_profile
echo 'export ANDROID_NDK_HOME=/usr/local/share/android-ndk' >> ~/.bash_profile
echo 'export INTEL_HAXM_HOME=/usr/local/Caskroom/intel-haxm' >> ~/.bash_profile

echo 'export PATH="$ANT_HOME/bin:$PATH"' >> ~/.bash_profile
echo 'export PATH="$MAVEN_HOME/bin:$PATH"' >> ~/.bash_profile
echo 'export PATH="$GRADLE_HOME/bin:$PATH"' >> ~/.bash_profile
echo 'export PATH="$ANDROID_HOME/tools:$PATH"' >> ~/.bash_profile
echo 'export PATH="$ANDROID_HOME/platform-tools:$PATH"' >> ~/.bash_profile
# echo 'export PATH="$ANDROID_HOME/build-tools/25.0.3:$PATH"' >> ~/.bash_profile
# @ref https://www.bram.us/2017/05/12/launching-the-android-emulator-from-the-command-line/
echo 'export PATH="$ANDROID_HOME/emulator:$PATH"' >> ~/.bash_profile

source ~/.bash_profile

# Android Studio itself
brew install --cask android-studio

# Configure Emulators
# @ref https://gist.github.com/Tanapruk/b05e97d68a5969b4402650094145e913
# @ref https://wiki.genexus.com/commwiki/servlet/wiki?14462,Creating+an+Android+Virtual+Device,
# @ref https://gist.github.com/handstandsam/f20c2fd454d3e3948f428f62d73085df
# @ref https://gist.github.com/mrk-han/66ac1a724456cadf1c93f4218c6060ae
sdkmanager --install "system-images;android-28;google_apis;x86"
echo "no" | avdmanager --verbose create avd --force --name "pixel_9.0" --device "pixel" --package "system-images;android-28;google_apis;x86" --tag "google_apis" --abi "x86"
echo "alias pixel_9.0='emulator @pixel_9.0 -no-boot-anim -netdelay none -no-snapshot -skin 1080x1920'" >> ~/.bash_profile

sdkmanager --install "system-images;android-29;google_apis;x86"
echo "no" | avdmanager --verbose create avd --force --name "pixel_10.0" --device "pixel" --package "system-images;android-29;google_apis;x86" --tag "google_apis" --abi "x86"
echo "alias pixel_10.0='emulator @pixel_10.0 -no-boot-anim -netdelay none -no-snapshot -skin 1080x1920'" >> ~/.bash_profile

sdkmanager --install "system-images;android-30;google_apis;x86"
echo "no" | avdmanager --verbose create avd --force --name "pixel_11.0" --device "pixel" --package "system-images;android-30;google_apis;x86" --tag "google_apis" --abi "x86"
echo "alias pixel_11.0='emulator @pixel_11.0 -no-boot-anim -netdelay none -no-snapshot -skin 1080x1920'" >> ~/.bash_profile

# Link up HW keyboard
for f in ~/.android/avd/*.avd/config.ini; do echo 'hw.keyboard=yes' >> "$f"; done

###############################################################################
# ALL DONE NOW!                                                               #
###############################################################################

echo -e "\n\033[93mSo, that should've installed all software for you …\033[0m"
echo -e "\n\033[93mYou'll have to install the following manually though:\033[0m"

echo "- Additional Tools for Xcode"
echo ""
echo "    Download from https://developer.apple.com/download/more/"
echo "    Mount the .dmg + install it from the Graphics subfolder"
echo ""