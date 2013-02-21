source /etc/profile

declare -x JAVA_OPTS="-Djava.awt.headless=true -XX:MaxPermSize=768m -XX:PermSize=512m -Xmx2048M -Xms256M -Dlog4j.configuration=log4j-prod.properties -XX:+UseParNewGC -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled -XX:-CMSParallelRemarkEnabled -XX:+UseStringCache -XX:+OptimizeStringConcat -XX:-PrintGCDetails -XX:-PrintGCTimeStamps -XX:-PrintTenuringDistribution -XX:-PrintCommandLineFlags"
declare -x CATALINA_HOME="${HOME}"
declare -x CATALINA_BASE="${HOME}"
#declare -x CATALINA_OPTS="DO NOT EVER SET CATALINA_OPTS UNLESS YOU CUSTOMIZE MEMORY USAGE FOR EACH SERVLET"
PATH="${PATH}:${HOME}/bin"

declare -x PS1="${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$"

#Aliases
alias la='ls -A'
alias l='ls -CF'
alias ls='ls --color=auto'
alias ll='ls -Falh --color=auto'
alias lh='ls -Falht --color=auto | head -n 15'
alias lg='ls -Falh  --color=auto | grep -i --color=auto'
alias grep='grep --color=auto -P'

