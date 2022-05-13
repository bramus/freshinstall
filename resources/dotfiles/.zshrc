# @ref https://github.com/paulirish/dotfiles/blob/master/.zshrc
# @ref https://medium.com/@falieson/setup-zsh-w-antigen-and-a-spacey-theme-7a66808218dc
# @ref https://github.com/ohmyzsh/ohmyzsh/wiki/Themes 

# @ref https://docs.brew.sh/Shell-Completion#configuring-completions-in-zsh
# $ brew install brew install zsh-completions
# $ chmod -R go-w '$(brew --prefix)/share/zsh'
if type brew &>/dev/null; then
    FPATH="$(brew --prefix)/share/zsh-completions:$FPATH"
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

    autoload -Uz compinit
    compinit
    # Getting "zsh compinit: insecure directories, run compaudit for list." warnings?
    # Fix with `compaudit | xargs chmod g-w`
fi

# Load antigen
source ~/antigen.zsh 

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle brew
antigen bundle brew-cask
antigen bundle command-not-found
antigen bundle node
antigen bundle npm
# antigen bundle unixorn/rvm-plugin
antigen bundle dotenv
antigen bundle macunha1/zsh-terraform

# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting

# Fuzzy History Search (1/2): Install Bundle
antigen bundle zsh-users/zsh-history-substring-search ./zsh-history-substring-search.zsh

# Load the theme.
# antigen theme robbyrussell
antigen theme half-life
# antigen theme itchy

# NVM
export NVM_COMPLETION=true
export NVM_LAZY_LOAD=true
antigen bundle lukechilds/zsh-nvm

# Tell Antigen that you're done.
antigen apply

# Fuzzy History Search (2/2): Key Bindings
zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

# Fix numeric keypad
# @ref https://superuser.com/questions/742171/zsh-z-shell-numpad-numlock-doesnt-work
bindkey -s "^[Op" "0"
bindkey -s "^[On" "."
bindkey -s "^[OM" "^M"
bindkey -s "^[Oq" "1"
bindkey -s "^[Or" "2"
bindkey -s "^[Os" "3"
bindkey -s "^[Ot" "4"
bindkey -s "^[Ou" "5"
bindkey -s "^[Ov" "6"
bindkey -s "^[Ow" "7"
bindkey -s "^[Ox" "8"
bindkey -s "^[Oy" "9"
bindkey -s "^[Ol" "+"
bindkey -s "^[Om" "-"
bindkey -s "^[Oj" "*"
bindkey -s "^[Oo" "/"
bindkey -s "^[OX" "="

# Aliases & Functions
alias publicip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0" #wireless
alias ipv4="ifconfig -a | grep -o 'inet \(\([0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+\)\|[a-fA-F0-9:]\+\)' | sed -e 's/inet //'"
alias ipv6="ifconfig -a | grep -o 'inet6 \(\([0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+\)\|[a-fA-F0-9:]\+\)' | sed -e 's/inet6 //'"
alias afconfig="ifconfig | pcregrep -M -o '^[^\t:]+:([^\n]|\n\t)*status: active'"
alias showdesktop="defaults write com.apple.finder CreateDesktop true && killall Finder"
alias hidedesktop="defaults write com.apple.finder CreateDesktop false && killall Finder"
alias togglemic="osascript -e 'set storedInputLevel to input volume of (get volume settings)' -e 'if storedInputLevel > 0 then' -e 'set volume input volume 0' -e 'display notification \"🔇 Muted\" with title \"Microphone Status\"' -e 'else' -e 'set volume input volume 100' -e 'display notification \"🔈 Unmuted\" with title \"Microphone Status\"' -e 'end if'"
alias flushdns="dscacheutil -flushcache && sudo killall -HUP mDNSResponder"
function zipallfolders() {
    for i in */; do (cd "$i"; zip -r "../${i%/}.zip" .); done
}
function unzipall() {
    find . -name '*.zip' -exec sh -c 'unzip -d "${1%.*}" "$1"' _ {} \;
}
function npmuo() {
    if [ -f package.json ]; then
        npm install $(npm outdated | cut -d' ' -f 1 | sed '1d' | xargs -I '$' echo '$@latest' | xargs echo)
    fi
}

# Automated Additions Below:
