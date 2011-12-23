##########
# Editors
##########

EDITOR='vim'
PAGER='less'
SVN_EDITOR='vim'

##########
# Paths
##########

export PATH="${HOME}/bin:${HOME}/.bin:/usr/local/bin:/usr/local/sbin:/usr/local/share/npm/bin:$PATH"

# Add Java 6 to my environment
export PATH="$PATH:/System/Library/Frameworks/JavaVM.framework/Versions/1.6/Home/bin"
export JAVA_HOME="/System/Library/Frameworks/JavaVM.framework/Versions/1.6/Home"
#export CATALINA_HOME=/Users/ray/tools/tomcat6

# Adding an appropriate MANPATH variable for use with MacPorts.
export MANPATH=/opt/local/share/man:$MANPATH

##########
# History
##########

setopt hist_ignore_dups     # ignore duplication command history list
setopt HIST_IGNORE_SPACE
setopt APPEND_HISTORY       # write history only when closing
setopt EXTENDED_HISTORY     # add more info
#setopt share_history       # share command history data
HISTFILE=~/.zsh_history
SAVEHIST=1000000
HISTSIZE=1000000

##########
# Prompt
##########

autoload -U colors
colors
setopt prompt_subst

PROMPT='%{$fg[green]%}$(date "+%a %H:%M:%S") %{$fg[cyan]%}%n@%m:%{$reset_color%}%{$fg[yellow]%}${PWD/#$HOME/~}%{$reset_color%} %{$fg[blue]%}$(vcprompt)%{$fg[green]%}$(rvm-prompt i v g)
%{$fg[green]%}→ %{$reset_color%}'


#################
# Configure zsh
#################

# I don't want corrections
setopt NOCORRECT
setopt NOCORRECTALL # Only want commands not args
setopt CLOBBER      # Allow redirect to clobber files

setopt autopushd pushdminus pushdtohome autocd pushdignoredups


# setopt PRINT_EXIT_VALUE

# Other tabbing options
# setopt NO_AUTO_MENU
# setopt BASH_AUTO_LIST

###############
# URL quoting
###############

# Quote pasted URLs
autoload url-quote-magic
zle -N self-insert url-quote-magic

# Allow for file truncation
NULLCMD=:

REPORTTIME=10 # Show elapsed time if command took more than X seconds
LISTMAX=0 # ask to complete if top of list would scroll off screen

###############
# Completions
###############

# Load completions for Ruby, Git, etc.
autoload compinit
compinit
fpath=($HOME/.zsh/Completion $fpath)

# Make CTRL-W delete after other chars, not just spaces
#WORDCHARS=${WORDCHARS//[&=\/;\!#%\{]}
WORDCHARS='*?[]~=&;!#$%^(){}'

# Emacs key bindings
bindkey -e

bindkey "\e[1~" beginning-of-line
bindkey "\e[2~" quoted-insert
bindkey "\e[3~" delete-char
bindkey "\e[4~" end-of-line
bindkey "\e[5~" beginning-of-history
bindkey "\e[6~" end-of-history
bindkey "\e[7~" beginning-of-line
bindkey "\e[8~" end-of-line
bindkey "\e[H" beginning-of-line
bindkey "\e[F" end-of-line
bindkey "\eOH" beginning-of-line
bindkey "\eOF" end-of-line
bindkey "\eOd" backward-word
bindkey "\eOc" forward-word 

# mappings for Ctrl/Option-left-arrow and Ctrl/Option-right-arrow for word moving
#bindkey "\e\e[C"  forward-word
#bindkey "\e\e[D"  backward-word


# Add rvm to my environment
[[ -s $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm