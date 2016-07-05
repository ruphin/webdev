#!/usr/bin/env bash
cd /app

# Install Nodejs packages
if [ -f /app/package.json ]; then
	npm install
fi

# Install Bower packages
if [ -f /app/bower.json ]; then
	bower install
fi

case "$1" in
shell)
	echo "Dropping to shell"
	exec bash
	;;
)
*)
	echo "gulp $1"
	gulp $1
	;;
esac
