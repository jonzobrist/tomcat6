#!/bin/bash

if [ -f "${HOME}/.bashrc" ]
then
	source ${HOME}/.bashrc
fi

BASE_DIR="${HOME}"
DIRS_TO_CLEAN="logarchive"
KEEP_DAYS=30
GZIP=1

for MY_DIR in ${DIRS_TO_CLEAN}
do
unset MY_PATH
MY_PATH="${BASE_DIR}/${MY_DIR}"
if [ -d "${MY_PATH}" ]
then
	echo "Deleting files in ${MY_PATH} older than ${KEEP_DAYS}"
	find ${MY_PATH} -type d -mtime +${KEEP_DAYS} -exec /bin/rm -Rf {} \;

	if [ "${GZIP}" ]
	then
		echo "Gzipping files in ${MY_PATH} at $(date)"
		find ${MY_PATH} -type f ! -iname "*gz" -exec /bin/gzip {} \;
	else
		echo "Not g-zipping files on ${MY_PATH} at $(date)"
	fi

else
	echo "${MY_PATH} does not exist, skipping at $(date)"
fi

done
