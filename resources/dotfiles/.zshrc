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
antigen bundle unixorn/rvm-plugin
antigen bundle dotenv

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

# Automated Additions Below:
