# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ]; then
    [ -e "$HOME/.dircolors" ] && DIR_COLORS="$HOME/.dircolors"
    [ -e "$DIR_COLORS" ] || DIR_COLORS=""
    eval "`dircolors -b $DIR_COLORS`"
    alias ls='ls --color=auto'
    #alias dir='ls --color=auto --format=vertical'
    #alias vdir='ls --color=auto --format=long'
	alias vi="vim"
fi

if [ ! -z "$__git_ps1" ]; then
	# export ps1
	export PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w$(__git_ps1 "(%s)") \$\[\033[00m\] '
else
	export PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w\$\[\033[00m\] '
fi
stty -ixon