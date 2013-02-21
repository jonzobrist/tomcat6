#!/bin/bash
GID="1012"
USER="tomcat2"
HOME="/usr/local/tomcat2"
source ${HOME}/.bashrc

MY_443=$(netstat -an | grep LIST|grep tcp | grep 443)
MY_IPTABLES_443=$(iptables -t nat -nL|grep ^REDIRECT | grep "dpt:443")
if [ "${MY_443}" ] || [ "${MY_IPTABLES_443}" ]
 then
	echo "Already Listening on 443"
 else 
	echo "Not listening on 443, forwarding to 8423"
	iptables -t nat -A PREROUTING -p tcp --dport 443 -j REDIRECT --to-port 8423
fi

su ${USER} -c "${HOME}/bin/startup.sh > ${HOME}/logs/init.log 2>&1 &"

sleep 30
