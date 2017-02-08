# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
	debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
	xterm-color)
		PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
		;;
	*)
		#	PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
		PS1='\[\033[1;32m\]\u@\h\[\033[00m\]:\[\033[1;33m\]\w\[\033[1;36m\]$(git_info)\[\033[00m\]\$ '
		;;
esac

# Comment in the above and uncomment this below for a color prompt
#PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# If this is an xterm set the title to user@host:dir
case "$TERM" in
	xterm*|rxvt*)
		PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
		;;
	*)
		;;
esac

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

#if [ -f ~/.bash_aliases ]; then
#    . ~/.bash_aliases
#fi

# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ]; then
	eval "`dircolors -b`"
	alias ls='_ls'
fi

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
	. /etc/bash_completion
fi

if [ -f ~/.git-completion.bash ]; then
	. ~/.git-completion.bash
fi

if [ -f ~/.django_bash_completion ]; then
	. ~/.django_bash_completion
fi


# Globals

export EDITOR=vi
export GDFONTPATH="$HOME/share/fonts"
# export LANG=en_US.UTF-8
export LANG=zh_TW.UTF-8
export PATH="$PATH:$HOME/bin:$HOME/.aspera/connect/bin"
export PERL_LOCAL_LIB_ROOT="/usr/local/lib/perl5";
export PERL_MB_OPT="--install_base /usr/local/lib/perl5";
export PERL_MM_OPT="INSTALL_BASE=/usr/local/lib/perl5";
export PERL5LIB="/usr/local/lib/perl5/lib/perl5/i486-linux-gnu-thread-multi:/usr/local/lib/perl5/lib/perl5";
export PATH="/usr/local/lib/perl5/bin:$PATH";
export TERM="xterm-256color"
export WORKON_HOME=$HOME/.virtualenvs

# Standard Aliases

alias cls='clear'
alias cp='cp -i'
alias du='du -h --max-depth=1'
alias h='history | grep'
alias mv='mv -i'
alias rm='_rm'
alias rrm='/bin/rm -i'	# real rm
alias vi='vim'

# Personal Aliases
alias nanoha='vim ~/nanoha'
alias e='exit'
alias q='exit'
alias topme='top -c -u $USER'
alias ts='tmux attach'
alias tx='tmux attach -d'
alias reload_apache='sudo service apache2 reload'
alias cd="venv_cd"

# Home Aliases
if [ -e $HOME/.alias ]; then
	. $HOME/.alias
fi

# Local Functions and Commands

function git_info {
	ref=$(git symbolic-ref HEAD 2> /dev/null) || return;
	last_commit=$(git log --pretty=format:%at -1 2> /dev/null) || return;

	now=`date +%s`;
	sec=$((now-last_commit));
	min=$((sec/60)); hr=$((min/60)); day=$((hr/24)); yr=$((day/365));
	if [ $min -lt 60 ]; then
		info="${min}m"
	elif [ $hr -lt 24 ]; then
		info="${hr}h$((min%60))m"
	elif [ $day -lt 365 ]; then
		info="${day}d$((hr%24))h"
	else
		info="${yr}y$((day%365))d"
	fi

	echo "(${ref#refs/heads/} $info)";
	#	echo "(${ref#refs/heads/})";
}

function _ls() {
	LANG=zh_TW.BIG5
	# /bin/ls -C --color=always $@ | /usr/bin/iconv -f big5 -t utf8
	/bin/ls -C --color=always $@
	LANG=zh_TW.UTF-8
}

function old() {
	day=$1; shift
	find . -maxdepth 1 -mtime +${day} $@
}

function _rm() {
	while [ $# -ge 1 ]; do
		mv -f "$1" $HOME/tmp
		echo "$1 deleted."
		shift
	done
}

function rmold() {
	find . -maxdepth 1 -mtime +$1 -exec rm -rf {} \;
}

# Automatically activate Git projects' virtual environments based on the
# directory name of the project. Virtual environment name can be overridden
# by placing a .venv file in the project root with a virtualenv name in it
function workon_cwd {
    # Check that this is a Git repo
    GIT_DIR=`git rev-parse --git-dir 2> /dev/null`
    if [ $? == 0 ]; then
        # Find the repo root and check for virtualenv name override
        GIT_DIR=`\cd $GIT_DIR; pwd`
        PROJECT_ROOT=`dirname "$GIT_DIR"`
        ENV_NAME=`basename "$PROJECT_ROOT"`
        if [ -f "$PROJECT_ROOT/.venv" ]; then
            ENV_NAME=`cat "$PROJECT_ROOT/.venv"`
        fi
        # Activate the environment only if it is not already active
        if [ "$VIRTUAL_ENV" != "$WORKON_HOME/$ENV_NAME" ]; then
            if [ -e "$WORKON_HOME/$ENV_NAME/bin/activate" ]; then
                source "$WORKON_HOME/$ENV_NAME/bin/activate" && export CD_VIRTUAL_ENV="$ENV_NAME"
            fi
        fi
    elif [ $CD_VIRTUAL_ENV ]; then
        # We've just left the repo, deactivate the environment
        # Note: this only happens if the virtualenv was activated automatically
        deactivate && unset CD_VIRTUAL_ENV
    fi
}

# New cd function that does the virtualenv magic
function venv_cd {
    \cd "$@" && workon_cwd
}

# Initinalize
workon_cwd

# vi:nowrap:sw=4:ts=4
