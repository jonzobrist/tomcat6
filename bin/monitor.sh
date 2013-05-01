#!/bin/bash
URL="https://MY_ELB_ADDRESS/service/api/account/"
RUNFILE="${HOME}/monitor.pid"
LOGFILE="${HOME}/logs/monitor.log"
HTML_STATUS="/tmp/web.html"
PING_STATUS="/var/www/web.html"
USER="CHECK_USER"
PASSWD="CHECK_USER_PASSWORD"

CHECK_FOR="ACTIVE"

if [ -f ${RUNFILE} ]
 then
  PID=$(cat ${RUNFILE})
  PID_RUNNING=$(ps -p ${PID} | grep -v 'PID' | grep [0-9])
  if [ "${PID_RUNNING}" ] && [ -f ${RUNFILE} ]
    then
      echo "Already running, exiting at `date`"
      echo "PID ${PID} running is ${PID_RUNNING}"
      exit 1
    else
      echo "Clearing stale PID file"
      /bin/rm ${RUNFILE}
      echo "$$" > ${RUNFILE}
    fi
 else
  echo "$$" > ${RUNFILE}
fi

echo "Web monitor check started at `date`" >> ${LOGFILE}
echo "<HTML><HEAD><TITLE>Monitor on `hostname` at `date`</TITLE><BODY>" > ${HTML_STATUS}
echo "<p><h3>`hostname` Monitor</h3>" >> ${HTML_STATUS}
echo "<hr>`date`<hr>" >> ${HTML_STATUS}

MY_RESULT=`/usr/bin/wget --timeout=15 --user=${USER} --password=${PASSWD} --no-check-certificate ${URL} -O - -o /dev/null | grep "${CHECK_FOR}"`

  if [ -n "${MY_RESULT}" ]
   then
    echo "${URL} up at `date`" >> ${LOGFILE}
#    echo "DEBUG: success with ${URL} and RESULT ${MY_RESULT}" >> ${LOGFILE}
    echo "<FONT color=green>ALL UP - </FONT><a href=\"${URL}\">${URL}</a> up at `date`" >> ${HTML_STATUS}
    echo "<br>" >> ${HTML_STATUS}
    #${HOME}/bin/up_url ${TOMCAT_NUM}
   else
    echo "<FONT color=red>DOWN - </FONT><a href=\"${URL}\">${URL}</a> failed result ${MY_RESULT} at `date`" >> ${HTML_STATUS}
    echo "<br>" >> ${HTML_STATUS}
    echo "${URL} failed with result ${MY_RESULT} at `date`" >> ${LOGFILE}
    ${HOME}/bin/restarttomcat
    ${HOME}/bin/page.sh "Tomcat down on `hostname` at `date`"

    DOWN=1
  fi
 TOMCAT_NUM=$[TOMCAT_NUM+1]

echo "Web monitor finished at `date`" >> ${LOGFILE}
echo "</BODY></HTML>" >> ${HTML_STATUS}
if [ -w "${PING_STATUS}" ]
then
    cat ${HTML_STATUS} > ${PING_STATUS}
else
    echo "Cannot create ${PING_STATUS}, skipping at $(date)"
fi
/bin/rm ${RUNFILE}
exit 0

