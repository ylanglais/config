#!/bin/zsh -x
#################################################################
#
# Environment Variable Setup for ZSHELL, File $HOME/.zshenv
#
#################################################################
#
# No core dump:
#
limit coredumpsize 0
#
# General mask for permission creation:
# (owner only)
umask 022
#
#	Export ALL variables
ALL_EXPORT=
#
# General environment settings:
#
export USER=`whoami`
export USERNAME=$USER 
export HOSTNAME=$HOST
export LANG="fr_FR.UTF-8"
export LANGUAGE="fr_FR:fr:en_GB:en"
export MORE='-c'
export VISUAL=vim
export EDITOR=vim
export PAGER=less
export TEMP=$HOME/tmp
export MYSHELL=zsh
export MYSHELLCOMMAND="`which $MYSHELL`"
export MYBIN=$HOME/bin
export IS_A_LOGIN_SHELL=False
#
# Hosts:
#
#	Load standard definitions:
#
#. $HOME/.sp.sh
#
#MWMSHELL=/bin/zsh
export X11LIB=/usr/lib/
export X11INC=/usr/include
export X11BIN=/usr/bin
export X11MAN=/usr/man
export X11HOME=/usr/
export XSYSTEM=/usr/
#
# Minimal path setting:
export PATH=/usr/local/bin:/usr/games/bin:/usr/sbin:/usr/bin:/bin:/sbin
export LD_LIBRARY_PATH=$HOME/lib:$LD_LIBRARY_PATH

#export XFILESEARCHPATH=$HOME/%T/%N%S:/etc/X11/app-defaults/%T/%N%S

#
# Sunstudio12: 
[ -d /opt/sunstudio12 ] && {
	export PATH=/opt/sunstudio12/bin:$PATH
	export LD_LIBRARY_PATH=$HOME/lib:/opt/sunstudio12/lib:/usr/local/lib:${LD_LIBRARY_PATH}
	export MANPATH=/opt/sunstudio12/man:$MANPATH
}

#
# Android Studio:
[ -d /opt/android-sdk-linux/platform-tools ] && { 
	export PATH=/opt/android-sdk-linux/platform-tools:$PATH
	jv=$(ls -d /opt/jdk* | tail -1)
	[ -n "$jv" ] && {
		export PATH=$jv/bin:$PATH
		export JAVA_HOME=$jv
	}
}
#
# Squirrel-sql:
[ -f /usr/sbin/squirrel-sql ] || {
[ -d /opt/squirrel-sql ] && {
	unset jv
	sqr=$(ls -d /opt/squirrel-sql* | tail -1)
	[ -n $sqr ] && export PATH=$sqr:$PATH
	unset $sqr
}
}
#
#Oracle stuff: 
[ -d /usr/lib/oracle/21/client64 ] && {
	export ORACLE_HOME=/usr/lib/oracle/21/client64
	LD_LIBRARY_PATH=${ORACLE_HOME}/lib:${LD_LIBRARY_PATH}
}
#
# Firefox, thunderbird, libreoffice & google chrome:
[ -d /opt/firefox             ] && export PATH=/opt/firefox:$PATH
[ -d /opt/thunderbird/        ] && export PATH=/opt/thunderbird:$PATH
[ -d /opt/libreoffice/program ] && export PATH=$PATH:/opt/libreoffice/program
[ -d /opt/google/chrome       ] && export PATH=/opt/google/chrome:$PATH

#
# AMABIS:
[ -d /opt/amabis              ] && export PATH=/opt/amabis/bin:$PATH
#
#
[ -d $HOME/tmp ] && export TMP=$HOME/tmp

#
# My local stuff:
export PATH=.:${HOME}/bin:${HOME}/scripts:${PATH}

alias pss="ps -auxw"
export PROCESSID=$$

[ -f ${HOME}/.proxy ] && . ${HOME}/.proxy
[ -f /usr/share/nvm/init-nvm.sh ]  && . /usr/share/nvm/init-nvm.sh
