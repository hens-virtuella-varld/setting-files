# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
	debian_chroot=$(cat /etc/debian_chroot)
fi

setopt PROMPT_SUBST
PS1=$'%B%F{magenta}%n%F{red}@%m%F{yellow}:%1d%F{cyan}$(git_info)\n%b%F{white}$ '

# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ]; then
	eval "`gdircolors -b`"
	alias ls='_ls'
fi

# some more ls aliases
export CLICOLOR=1
alias ls='pwd; ls'
alias ll='ls -la'
alias l.='ls -d .* --color=auto'
#alias la='ls -A'
#alias l='ls -CF'

# cd
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../../../'
alias ....='cd ../../../../'
alias .....='cd ../../../../../'
alias .4='cd ../../../../'
alias .5='cd ../../../../../'

# grep
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

alias bc='bc -l' # calculator
alias mkdir='mkdir -pv' # create parent
alias h='history'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
	. /etc/bash_completion
fi

if [ -f ~/.django_bash_completion ]; then
	. ~/.django_bash_completion
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm

# Globals

export EDITOR=vim
export GDFONTPATH="$HOME/share/fonts"
# export LANG=en_US.UTF-8
export LANG=zh_TW.UTF-8
export PATH="$PATH:$HOME/bin:$HOME/.aspera/connect/bin:/Applications/Postgres.app/Contents/Versions/9.6/bin/:/usr/local/sbin"
export WORKON_HOME="$HOME/.virtualenvs/"

# Standard Aliases

alias cls='clear'
alias cp='cp -i'
alias du='du -h --max-depth=1'
alias h='history | grep'
alias mv='mv -i'
alias vi='vim'
alias svi='sudo vi'

# Personal Aliases
alias nanoha='vi ~/nanoha'
alias n='vi ~/nanoha'
alias e='exit'
alias q='exit'
alias topme='top -c -u $USER'
alias tl='tmux ls'
alias ts='tmux new -A -s'
alias tx='tmux new -A -D -s'
alias cd="venv_cd"
alias cdr='cd $(git root)'
alias c='clear'
alias ports='netstat -tulanp'
alias top='atop'
alias df='df -H'
alias g='git'
alias gfi="git flow init"
alias gff="git flow feature"
alias gfr="git flow release"
alias gfh="git flow hotfix"
alias gfs="git flow support"
alias cta-koa="git clone https://github.com/ylhuang0423/koa-starter ."
alias y="yarn"
alias ys="yarn start"
alias yt="yarn test"
alias yl="yarn lint"
alias c="code"
alias vsc="code"
alias cx="chmod +x"
alias dc="docker-compose"
alias dcl="docker-compose logs --tail 20 -f"
function dcb() { docker-compose exec $@ /bin/bash; }

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
	# /bin/gls -C --color=always $@ | /usr/bin/iconv -f big5 -t utf8
	/bin/gls -C --color=always $@
	LANG=zh_TW.UTF-8
}

# Automatically activate Git projects' virtual environments based on the
# directory name of the project. Virtual environment name can be overridden
# by placing a .venv file in the project root with a virtualenv name in it
function workon_cwd {
    # Check that this is a Git repo
    GIT_DIR=`git rev-parse --git-dir 2> /dev/null`
    if [ $? '==' 0 ]; then
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
        source deactivate && unset CD_VIRTUAL_ENV
    fi
}

# New cd function that does the virtualenv magic
function venv_cd {
    \cd "$@" && workon_cwd
}

function set_vpn_net {
    sudo route delete -net default -interface ppp0
    sudo route add -net 0.0.0.0 -interface en0
    sudo route add -net 172.18.0.0 -netmask 255.255.0.0 -interface ppp0
}

# Initinalize
workon_cwd

DIR=Ex
SYM_LINK=Gx
SOCKET=Fx
PIPE=dx
EXE=Cx
BLOCK_SP=Dx
CHAR_SP=Dx
EXE_SUID=hb
EXE_GUID=ad
DIR_STICKY=Ex
DIR_WO_STICKY=Ex
export LSCOLORS="$DIR$SYM_LINK$SOCKET$PIPE$EXE$BLOCK_SP$CHAR_SP$EXE_SUID$EXE_GUID$DIR_STICKY$DIR_WO_STICKY"

# tabtab source for yarn package
# uninstall by removing these lines or running `tabtab uninstall yarn`
[ -f /Users/nanoha/.config/yarn/global/node_modules/tabtab/.completions/yarn.bash ] && . /Users/nanoha/.config/yarn/global/node_modules/tabtab/.completions/yarn.bash

[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh
export PATH="/usr/local/opt/ruby/bin:$PATH"
