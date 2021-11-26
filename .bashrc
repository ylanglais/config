# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

export LANG="fr_FR.UTF-8"
export LANGUAGE="fr_FR:fr:en_GB:en"


# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi
#export DISPLAY=:0.0

#
# Get a session number:
export MYSHELL=bash
export Shell=bash
PROCESSID=$$; export PROCESSID
[ -f $HOME/.aliases/.$Shell ] && . $HOME/.aliases/.$Shell
[ x"$REQSSID" != x ] && {
	SessionID=$REQSSID
	unset REQSSID
} || { 
	exec 3>&1
	pid=$$
	SessionID=$(~/scripts/session_new $pid)
}
HISTFILE=$HOME/.histfiles/.$Shell.$HOST.$SessionID; export HISTFILE

if [ "$TERM" != "dumb" ]; then
	[ -f ~/scripts/setcolors.ksh ] && . ~/scripts/setcolors.ksh
fi

export HISTCONTROL=ignoredups

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

dbname() {
	[ -z $DBNAME ] || { 
		echo "$white:$bold$DBNAME$norm " 
	}
}
prj() {
	[ -z $PRJ ] && dbname || {
		[ -n $DBNAME ] && echo "$white$bold$PRJ$norm:$bold$DBNAME$norm:$bold$PRJENV$norm " || echo "$white$bold$PRJ$norm::$bold$PRJENV "
	}	
}
# set a fancy prompt (non-color, unless we know we "want" color)
PS1='
$bold${magenta}\! ${blink}${green}${Shell}${noblink}${green}${bold}-${SessionID} $(prj)${bold}${blue}${USER}@${HOSTNAME}:${yellow}$(pwd)$norm
'

[ "$TERM" = "xterm" -o "$TERM" = "rxvt" ] && {
    # for xterm ESC ] 2 is title of window, 1 is icon name, 0 is both
    xtitle() {
        (echo -n ""]2\;"$*""") >&2
    }
    xicon() {
        (echo -n ""]1\;"$*""") >&2
    }
    xnames() {
        xtitle "$*"
        xicon "$*"
    }
	xnames "$HOST-$MYSHELL-$SessionID $PWD"
	true
} || {
	xtitle() {
		echo -n ""
	}
	xicon() {
		echo -n ""
	}
	xname() {
		echo -n ""
	}
}

[ -f ${HOME}/.proxy ] && . ${HOME}/.proxy

#export all_proxy="socks://192.168.47.100:6060"
#export http_proxy="http://192.168.47.100:6060"
#export https_proxy="http://192.168.47.100:6060"
#export ftp_proxy="http://192.44.63.51:6060"
#export no_proxy="localhost,127.0.0.0/8,.noc.credit-agricole.fr,.yla"
#export ALL_PROXY=$all_proxy
#export HTTP_PROXY=$http_proxy
#export HTTPS_PROXY=$https_proxy
#export FTP_PROXY=$ftp_proxy
#export NO_PROXY=$no_proxy
