FROM node:8

### Create user and group ###
RUN deluser node \
	&& addgroup app \
	&& useradd app --create-home -g app

### Install GOSU
ENV GOSU_VERSION 1.10
RUN set -ex; \
	\
	dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')"; \
	wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch"; \
	wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc"; \
	\
	# verify the signature
	export GNUPGHOME="$(mktemp -d)"; \
	gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4; \
	gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu; \
	rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc; \
	\
	chmod +x /usr/local/bin/gosu; \
	# verify that the binary works
	gosu nobody true;

### Update to latest Yarn
ENV YARN_VERSION 1.1.0

RUN set -ex \
	&& curl -fSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz" \
	&& curl -fSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz.asc" \
	&& gpg --batch --verify yarn-v$YARN_VERSION.tar.gz.asc yarn-v$YARN_VERSION.tar.gz \
	&& mkdir -p /opt/yarn \
	&& tar -xzf yarn-v$YARN_VERSION.tar.gz -C /opt/yarn --strip-components=1 \
	&& rm /usr/local/bin/yarn \
	&& rm /usr/local/bin/yarnpkg \
	&& ln -s /opt/yarn/bin/yarn /usr/local/bin/yarn \
	&& ln -s /opt/yarn/bin/yarn /usr/local/bin/yarnpkg \
	&& rm yarn-v$YARN_VERSION.tar.gz.asc yarn-v$YARN_VERSION.tar.gz

### Install Gulp and Bower
RUN yarn global add gulp bower

COPY bootstrap.sh /bootstrap.sh
COPY run.sh /home/app/run.sh
ENTRYPOINT ["/bootstrap.sh"]
