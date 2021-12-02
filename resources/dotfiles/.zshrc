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

# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting

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

# bind UP and DOWN arrow keys for history search
zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

# Automated Additions Below:
