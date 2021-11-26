#
#       Define aliases and functions:
#

#alias | grep rm 1>/dev/null 2>&1 && unalias rm
alias | grep "^mv=" 1>/dev/null 2>&1 && unalias mv
alias | grep "^cp=" 1>/dev/null 2>&1 && unalias cp
#
alias j=jobs
alias grep="grep --color"
alias egrep="egrep --color"
alias fgrep="fgrep --color"
alias ls="ls -CF --color=auto"
alias l=" ls -CFA --color=auto"
alias la="ls -CFAl --color=auto"
alias ll="ls -CFl --color=auto"
alias lt="ls -CFlrt --color=auto"
alias lS='ls -lS --color'
alias lrs='ls -lrS  --color'
alias las='ls -alS  --color'
alias lar='ls -alrS --color'

alias h="history -1000"
alias hg="history -1000 | grep"
alias pss='ps auxw | egrep $(whoami)"|USER" | egrep -v "grep|ps auxw" | sort -n +1'

alias hd='hexdump -Cv'
alias make='make --no-print-directory'
alias wg="wget -l2 -rF"
alias g='wget -l2 -rF -A mpg'
alias v='wget -l2 -rF -A wmv'

rot13() {    
    if [ $# = 0 ]
	then
        tr "[a-m][n-z][A-M][N-Z]" "[n-z][a-m][N-Z][A-M]"  
    else
        tr "[a-m][n-z][A-M][N-Z]" "[n-z][a-m][N-Z][A-M]" < $1
    fi
}  

psg() {
    ps -auxx | grep `whoami` | grep $1 | grep -v grep
}   
function ff {
    find . -name $* -print
}

function chpwd() {    
	Pwd=`pwd`
	xtitle "`hostname`-${Shell}-${SessionID} ${Pwd}"
	xicon "`hostname`-${Shell}-${SessionID} `basename ${Pwd}`"
	\ls -CF --color=auto
}    
cd() { 
    builtin cd $*
	xtitle "`hostname`-${Shell}-${SessionID} ${Pwd}"
	xicon "`hostname`-${Shell}-${SessionID} `basename ${Pwd}`"
	\ls -CF --color=auto
}

ssg () {
	(xtitle "$*i"; xicon "$*i") 1>/dev/null 2>&1 
	/usr/local/bin/ssg "$*"
	(xtitle "`hostname`-${Shell}-${SessionID} ${Pwd}"; xicon "`hostname`-${Shell}-${SessionID}") 1>/dev/null 1>&2 
}
#
br() {
	echo ""
}
rcmd() {
	host=$1; shift
	( /usr/local/bin/ssg $host $* ) 2>&1 | tr -d "\r" |grep -v "Connection to services-sshgate closed."
}
differ() {
	host1=$1
	host2=$2
	file=$3;
	chk=$(rcmd $host1 ls $file | tr -d '\r') 
	if [ "$chk" == "$file" ] 
	then 
		echo "$cyan$file diff between $host1 and $host2:$norm"
		(rcmd $host1 cat $file) > $host1.tmp
		(rcmd $host2 cat $file) > $host2.tmp
		diff -w $host1.tmp $host2.tmp && echo "$green"files are identical$norm
		return $?
	else 
		echo "${red}No $file on $host1$norm"
	fi
}
diffdir() {
	host1=$1
	host2=$2
	dir=$3;
	echo "$cyan$dir directory diff between $host1 and $host2:$norm"
	(rcmd $host1 "cksum $dir/* 2>/dev/null")|sort -k 3 > $host1.tmp
	(rcmd $host2 "cksum $dir/* 2>/dev/null")|sort -k 3 > $host2.tmp
	diff -w $host1.tmp $host2.tmp && echo "$green"directories are identical 
	return $?
}
diffcmd() {
	host1=$1; shift
	host2=$1; shift
	cmd=$*;
	echo "$cyan$cmd diff between $host1 and $host2:$norm"
	(rcmd $host1 $cmd) > $host1.tmp
	(rcmd $host2 $cmd) > $host2.tmp
	diff -w $host1.tmp $host2.tmp && echo "$green"cmd results are identical$norm
}

mdays() {
	while [ -n "$1" ] 
	do  
		echo "$1": $(( ( $(date +%s) - $(stat -c %Y "$1") ) / 3600 / 24 ))
		shift
	done
}

[ -f ~/.hosts ] && . ~/.hosts

sete() {
	e=$1
	[ -f ~/.prjs ] || {
		echo $bold${red}No project definiton${norm}
	} 
	export PRJ=$e
	export DBNAME=$(grep "^$e:" ~/.prjs|cut -d: -f2)
	export PRJDIR=$(eval echo $(grep "^$e:" ~/.prjs|cut -d: -f3))
	export PRJENV=$(grep "^$e:" ~/.prjs|cut -d: -f4)
	cd $PRJDIR
}
_sete() {
	local cur=${COMP_WORDS[COMP_CWORD]}
    COMPREPLY=( $( compgen -W "$(cut -d: -f1 ~/.prjs)" -- "$cur" ) ) 
}
#
#
dsvg() {
	[ $# -lt 1 ] && {
		echo "specify directory to save"
		return
	} 
	rep=$1
	suf=""
	[ $# -gt 1 ] && suf=".$2"
	d=`date +"%Y%m%d"`
	name=$rep.$d$suf.tgz
	[ -e $name ] && {
		val=$(ls -C1 $rep.$d.[0-9]{1,}$suf.tgz 2>/dev/null | tail -1 | sed -e "s/^$rep.$d.\([0-9]\{1,\}\)$suf.tgz$/\1/g")
		[ -z $val ] && val=1 || let val=val+1
		name=$rep.$d.$val$suf.tgz 	
	}
	echo "Saving $bold$green$1$norm directory to "$bold$yellow$name$norm
	tar czf $name $rep
}
_dsvg() { reply=(`ls`); }
#
#	Mysql stuff
#
ms() {
	mysql  $DBNAME -rs --disable-pager -e "$*"
}
msl() {
	mysql  $DBNAME -rs --disable-pager -e "$*"
}
lsdb() {
	ms show databases | head -n -1 | sort
}
#
#
setdb() {
	export DBNAME=$1
}
#compdef setdb
_lsdb() {
	local cur=${COMP_WORDS[COMP_CWORD]}
    COMPREPLY=( $( compgen -W "$(mysqlshow 2>/dev/null|sed -ne '2d' -e 's/^|.\([^|]*\)|.*/\1/p')" -- "$cur" ) ) 
}
#
#
lsdb() {
	ms show databases | head -n -1 | sort
}
lstab() {
	[ -z "$DBNAME" ] && echo  "No database set (use setdb)" || {
		ms show tables | head -n -1 | sort
	}
}
#
#	Dump a database:
#
dumpdb() {
	[ $# -lt 1 ] && {
		echo "${yellow}dumpdb usage:$norm"
		echo "dumpdb ${yellow}dbname $blue[suffix]$norm"
		return 1
	}	 
	dbname=$1
	[ $# -gt 1 ] && suffix=".$2" || suffix=""
	
	d=`date +"%Y%m%d"`
	name=$dbname.$d$suffix.sql 	
	[ -e $name ] && {
		val=$(ls -C1 $dbname.$d.[0-9]{1,}$suffix.sql 2>/dev/null | tail -1 | sed -e "s/^$dbname.$d.\([0-9]\{1,\}\)$suffix.sql$/\1/g")
		[ -z $val ] && val=1 || let val=val+1
		name=$dbname.$d.$val$suffix.sql 	
	}
	echo "Dump database $bold$green$dbname$norm to $bold$yellow$name$norm"
	mysqldump $dbname > $name
}

#
#	Dump a database:
#
dumpmodel() {
	[ $# -lt 1 ] && {
		echo "${yellow}dumpmodel usage:$norm"
		echo "dumpmodel ${yellow}dbname $blue[suffix]$norm"
		return 1
	}	 
	dbname=$1
	[ $# -gt 1 ] && suffix=".$2" || suffix=""
	
	d=`date +"%Y%m%d"`
	name=$dbname.model.$d$suffix.sql 	
	[ -e $name ] && {
		val=$(ls -C1 $dbname.model.$d.[0-9]{1,}$suffix.sql 2>/dev/null | tail -1 | sed -e "s/^$dbname.model.$d.\([0-9]\{1,\}\)$suffix.sql$/\1/g")
		[ -z $val ] && val=1 || let val=val+1
		name=$dbname.model.$d.$val$suffix.sql 	
	}
	echo "Dump database model $bold$green$dbname$norm to $bold$yellow$name$norm"
	mysqldump -d $dbname > $name
}

#
# truncate database after saving it;
#
truncatedb() {
	[ $# -lt 1 ] && {
		echo "${yellow}truncatedb usage:$norm"
		echo "truncatedb ${yellow}dbname$norm"
		return 1
	}	 
	dbname=$1
	dumpdb $dbname before_truncation
	echo "Truncate database $bold$green$dbname$norm"
	mysql -e "drop database $dbname; create database $dbname"
}

complete -F _sete sete
complete -F _lsdb lsdb
complete -F _lsdb setdb
complete -F _lsdb mysql
complete -F _lsdb mysqldump
complete -F _lsdb dumpdb
complete -F _lsdb dumpmodel
complete -F _lsdb truncatedb
