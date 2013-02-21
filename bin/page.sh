#!/bin/bash
#Author : dougnaka@gmail.com
#Description : Quick alert/page script, uncomment and edit EMAIL="" 
#include a comma separated list of emails to send to
#Usage : page.sh "Short or long message"
#EMAIL="root@example.com,address2@example.com"
if [ "${1}" ] && [ "${EMAIL}" ]
 then
  SUBJECT="[ALERT] ${1}"
  EMAILMESSAGE="/tmp/`date +%s`-message"
  echo "ALERT: at `date`" > ${EMAILMESSAGE}
  echo "${1}" >> ${EMAILMESSAGE}
  echo "From `hostname`" >> ${EMAILMESSAGE}
  mail -s "${SUBJECT}" "${EMAIL}" < ${EMAILMESSAGE}
  /bin/rm ${EMAILMESSAGE}
else
 if [ "${EMAIL}" ]
  then
   echo "Usage: ${0} MESSAGE"
   exit 1
 fi
fi
