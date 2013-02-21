#!/bin/bash
source ${HOME}/.bashrc
MY_DIR="$(date +%F-%s)"
MY_PROCESS="org.apache.catalina.startup.Bootstrap"
MAX_COUNT=30

function kill_mypid () {
    KILL_PID=${1}
    COUNT=0
    echo -n "Killing PID ${KILL_PID}"
    while ps --pid ${KILL_PID} | grep -q [0-9]
    do
        echo -n "Killing PID ${KILL_PID}"
        if [ ${COUNT} -gt ${MAX_COUNT} ]
        then
            kill -9 ${KILL_PID}
        else
            kill ${KILL_PID}
        fi
        ((COUNT++))
        echo -n "."
        sleep 1
    done
    echo "killed"
}


MY_PID=$(pgrep -u $(whoami) -f -o ${MY_PROCESS})
if [ "${MY_PID}" ] && [ -x "${CATALINA_HOME}/bin/shutdown.sh" ]
then
    ${CATALINA_HOME}/bin/shutdown.sh 
    sleep 3
    echo -n "${MY_PROCESS} PID is ${MY_PID}"
    MY_STOPPED_PID=$(ps -p ${MY_PID})
    if [ "${MY_STOPPED_PID}" ]
    then
        kill_mypid ${MY_PID}
    else
        echo "Stopped"
        exit 0
    fi
else
    echo "we has no valid config to clean, or pid to kill"
    exit 0
fi

