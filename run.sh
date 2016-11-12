#!/usr/bin/env bash
cd /app

# Install Nodejs packages
if [ -f /app/package.json ]; then
	yarn
fi

# Install Bower packages
if [ -f /app/bower.json ]; then
	bower --allow-root install
fi

case "$1" in
shell)
	echo "Dropping to shell"
	exec bash
	;;
*)
	echo "gulp $1"
	gulp $1
	;;
esac
