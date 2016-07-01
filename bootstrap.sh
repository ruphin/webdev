#!/usr/bin/env bash

# Configure the user
ID=`stat -c '%u' /app`
GID=`stat -c '%g' /app`
if [ -z "$ID" ] || [ -z "$GID" ]; then
	echo "Failed to detect the user or group ID for the app"
	exit 1
fi

usermod -u $ID app
groupmod -g $GID app
chown -R app:app /home/app
sync

gosu app /home/app/run.sh $1
