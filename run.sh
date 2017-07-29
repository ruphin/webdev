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

exec $1
