source ~/.profile

# color my prompt!
source ~/.bash_prompt

# Load in .bashrc
source ~/.bashrc

# autocomplete git branches
# @ref https://raw.github.com/git/git/master/contrib/completion/git-completion.bash
source ~/.git-completion.sh

# Makefile autocompletion
# @ref http://stackoverflow.com/a/36044470/2076595
function _makefile_targets {
    local curr_arg;
    local targets;

    # Find makefile targets available in the current directory
    targets=''
    if [[ -e "$(pwd)/Makefile" ]]; then
        targets=$( \
            grep -oE '^[a-zA-Z0-9_-]+:' Makefile \
            | sed 's/://' \
            | tr '\n' ' ' \
        )
    fi

    # Filter targets based on user input to the bash completion
    curr_arg=${COMP_WORDS[COMP_CWORD]}
    COMPREPLY=( $(compgen -W "${targets[@]}" -- $curr_arg ) );
}
complete -F _makefile_targets make

# ls
alias la="ls -alG"

# IP addres aliases
alias publicip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0" #wireless
alias ipv4="ifconfig -a | grep -o 'inet \(\([0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+\)\|[a-fA-F0-9:]\+\)' | sed -e 's/inet //'"
alias ipv6="ifconfig -a | grep -o 'inet6 \(\([0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+\)\|[a-fA-F0-9:]\+\)' | sed -e 's/inet6 //'"
alias afconfig="ifconfig | pcregrep -M -o '^[^\t:]+:([^\n]|\n\t)*status: active'"

# show/hide dekstop icons
alias showdesktop="defaults write com.apple.finder CreateDesktop true && killall Finder"
alias hidedesktop="defaults write com.apple.finder CreateDesktop false && killall Finder"

# Toggle Microphone
alias togglemic="osascript -e 'set storedInputLevel to input volume of (get volume settings)' -e 'if storedInputLevel > 0 then' -e 'set volume input volume 0' -e 'display notification \"🔇 Muted\" with title \"Microphone Status\"' -e 'else' -e 'set volume input volume 100' -e 'display notification \"🔈 Unmuted\" with title \"Microphone Status\"' -e 'end if'"

# Flush Directory Service cache
alias flushdns="dscacheutil -flushcache && sudo killall -HUP mDNSResponder"

# fix openwith dupes + kill Finder + open TotalFinder
alias lscleanup='/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder && open /Applications/TotalFinder.app'

# Remember SSH Keys between reboots
# @ref http://apple.stackexchange.com/questions/254468/macos-sierra-doesn-t-seem-to-remember-ssh-keys-between-reboots
ssh-add -A &> /dev/null
