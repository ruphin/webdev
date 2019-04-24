FROM node:11.9.0

### Create user and group ###
RUN deluser node \
	&& addgroup app \
	&& useradd app --create-home -g app

### Install chrome
RUN apt-get update && apt-get install -y \
	apt-transport-https \
	--no-install-recommends \
	&& curl -sSL https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
	&& echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list \
	&& apt-get update && apt-get install -y \
	google-chrome-stable \
	--no-install-recommends \
	&& apt-get purge --auto-remove -y \
	&& rm -rf /var/lib/apt/lists/*

### Install a bunch of standard libs and utilities that are required for building common nodejs modules
RUN apt update \
	&& apt install -yq gconf-service libasound2 libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 \
	libexpat1 libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 \
	libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 \
	libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 \
	ca-certificates fonts-liberation libappindicator1 libnss3 lsb-release xdg-utils wget \
	&& rm -rf /var/lib/apt/lists/*
	
### Install GOSU
RUN set -eux; \
	apt update; \
	apt install -y gosu; \
	rm -rf /var/lib/apt/lists/*; \
# verify that the binary works
	gosu nobody true

COPY bootstrap.sh /bootstrap.sh
COPY run.sh /home/app/run.sh
ENTRYPOINT ["/bootstrap.sh"]
