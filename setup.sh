#!/bin/bash
GID="1012"
USER="tomcat2"
USER_HOME="/usr/local/tomcat2"
groupadd -g ${GID} ${USER}
useradd -M -d ${USER_HOME} -s /bin/bash -u ${GID} -g ${GID} ${USER}

chown -R ${USER}:${USER} ${USER_HOME}
chown -R ${USER}:${USER} ${USER_HOME}/
#DEBUG=1
############################################################################################
#
# Start of parse_user_data.sh
#
############################################################################################
LATEST_URL="http://169.254.169.254/latest/user-data"
USER_DATA_FILE="/etc/user-data.conf"
TMP_FILE="/tmp/latest-data-`date +%F-%s`-tmp"
touch ${TMP_FILE}
if [ -f ${TMP_FILE} ]
 then
       if [ -f ${USER_DATA_FILE} ]
	then
		/bin/cp ${USER_DATA_FILE} ${TMP_FILE}
	else
		curl -o ${TMP_FILE} ${LATEST_URL}
	fi
 else
	echo "Failed to create temp file ${TMP_FILE} at $(date), Exiting"
	exit 1
fi
AMI="$(grep AMI ${TMP_FILE} | awk '{ print $2 }')"
BASE="$(grep BASE ${TMP_FILE} | awk '{ print $2 }')"
COMMANDS="$(grep COMMANDS ${TMP_FILE} | awk '{ print $2 }')"
DISK_DEVICE="$(grep DISK_DEVICE ${TMP_FILE} | awk '{ print $2 }')"
EC2_RUN_OPTS="$(grep EC2_RUN_OPTS ${TMP_FILE} | awk '{ print $2 }')"
F_INSTALL_PACKAGES="$(grep F_INSTALL_PACKAGES ${TMP_FILE} | awk '{ print $2 }')"
GROUP="$(grep GROUP ${TMP_FILE} | awk '{ print $2 }')"
HOST_NAME="$(grep HOST_NAME ${TMP_FILE} | awk '{ print $2 }')"
INSTANCE_TYPE="$(grep INSTANCE_TYPE ${TMP_FILE} | awk '{ print $2 }')"
J_INSTALL_PHASE2_PACKAGES="$(grep J_INSTALL_PHASE2_PACKAGES ${TMP_FILE} | awk '{ print $2 }')"
K_SSH_CMD="$(grep K_SSH_CMD ${TMP_FILE} | awk '{ print $2 }')"
LOCATION="$(grep LOCATION ${TMP_FILE} | awk '{ print $2 }')"
MYSQL_ROOT_PASSWORD="$(grep MYSQL_ROOT_PASSWORD ${TMP_FILE} | awk '{ print $2 }')"
NS_SERVERS="$(grep NS_SERVERS ${TMP_FILE} | awk '{ print $2 }')"
O_VOXEO_TOKEN="$(grep O_VOXEO_TOKEN ${TMP_FILE} | awk '{ print $2 }')"
PRIV_KEY_NAME="$(grep PRIV_KEY_NAME ${TMP_FILE} | awk '{ print $2 }')"
Q_GOOGLE_ANALYTICS_KEY="$(grep Q_GOOGLE_ANALYTICS_KEY ${TMP_FILE} | awk '{ print $2 }')"
REGION="$(grep REGION ${TMP_FILE} | awk '{ print $2 }')"
SILO_NAME="$(grep SILO_NAME ${TMP_FILE} | awk '{ print $2 }')"
TIWIPRO_SERVER_ID="$(grep TIWIPRO_SERVER_ID ${TMP_FILE} | awk '{ print $2 }')"
U_USER="$(grep U_USER ${TMP_FILE} | awk '{ print $2 }')"
VOLUME_SIZE="$(grep VOLUME_SIZE ${TMP_FILE} | awk '{ print $2 }')"
Y_SILO_ID="$(grep Y_SILO_ID ${TMP_FILE} | awk '{ print $2 }')"
ZONE="$(grep ZONE ${TMP_FILE} | awk '{ print $2 }')"
if [ -z "${DEBUG}" ]
 then
echo $AMI
echo $BASE
echo $COMMANDS
echo $DISK_DEVICE
echo $EC2_RUN_OPTS
echo $F_INSTALL_PACKAGES
echo $GROUP
echo $HOST_NAME
echo $INSTANCE_TYPE
echo $J_INSTALL_PHASE2_PACKAGES
echo $K_SSH_CMD
echo $LOCATION
echo $MYSQL_ROOT_PASSWORD
echo $NS_SERVERS
echo $O_VOXEO_TOKEN
echo $PRIV_KEY_NAME
echo $Q_GOOGLE_ANALYTICS_KEY
echo $REGION
echo $SILO_NAME
echo $TIWIPRO_SERVER_ID
echo $U_USER
echo $VOLUME_SIZE
echo $Y_SILO_ID ZONE
fi
/bin/rm ${TMP_FILE}
############################################################################################
#
# End of parse_user_data.sh
#
############################################################################################


TIWIPRO_CLIENT_CENT_SERVER="${SILO_NAME}-node0.tiwipro.com"
MY_ELB_ADDRESS="${SILO_NAME}.inthinc.com"
echo "User home ${USER_HOME}"
perl -pi -e "s/WEB_DB_SERVER/${TIWIPRO_CLIENT_CENT_SERVER}/g" ${USER_HOME}/conf/tiwipro.properties
perl -pi -e "s/WEB_DB_USER/portalUser/g" ${USER_HOME}/conf/tiwipro.properties
perl -pi -e "s/WEB_DB_PASSWORD/portalPass/g" ${USER_HOME}/conf/tiwipro.properties
perl -pi -e "s/TIWIPRO_CLIENT_DB_SERVER/${TIWIPRO_CLIENT_CENT_SERVER}/g" ${USER_HOME}/conf/tiwipro.properties
perl -pi -e "s/MY_ELB_ADDRESS/${MY_ELB_ADDRESS}/g" ${USER_HOME}/conf/tiwipro.properties
perl -pi -e "s/TIWIPRO_SERVER_ID/${TIWIPRO_SERVER_ID}/g" ${USER_HOME}/conf/tiwipro.properties
perl -pi -e "s/VOXEO_TOKEN/${O_VOXEO_TOKEN}/g" ${USER_HOME}/conf/tiwipro.properties
perl -pi -e "s/GOOGLE_ID/${Q_GOOGLE_ANALYTICS_KEY}/g" ${USER_HOME}/conf/tiwipro.properties
perl -pi -e "s/MY_POSTGRES_SERVER/tp-mapserv0.tiwipro.com/g" ${USER_HOME}/conf/tiwipro.properties
perl -pi -e "s/POSTGRES_USER/proprod/g" ${USER_HOME}/conf/tiwipro.properties
perl -pi -e "s/POSTGRES_PASSWORD/du0Oifo5aeth9ei/g" ${USER_HOME}/conf/tiwipro.properties

if [ -f "${USER_HOME}/cron" ]
 then
	crontab -u ${USER} ${USER_HOME}/cron
fi
touch /var/www/web.html
chown ${USER}:${USER} /var/www/web.html


