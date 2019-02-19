#!/usr/bin/env bash
cd /app

# Install Nodejs packages
if [ -f "/app/package.json" ]; then
	npm install
fi

echo "Running: $@"
exec $@
