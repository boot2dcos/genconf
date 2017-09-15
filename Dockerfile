FROM fedora:25

LABEL maintainer vouillaume.benjamin@gmail.com
ARG DCOS_INSTALLER_URL

ARG DOCKER_TGZ_URL="https://get.docker.com/builds/Linux/x86_64/docker-17.05.0-ce.tgz"
ENV DOCKER_TGZ_URL $DOCKER_TGZ_URL

RUN set -ex; \
	curl -fSL $DOCKER_TGZ_URL -o docker.tgz; \
	tar -xzvf docker.tgz; \
	mv docker/* /usr/local/bin/; \
	rmdir docker; \
    rm docker.tgz;

# Tweak DCOS install script to use the shared volume boot2dcos_genconf
RUN set -ex; \
	mkdir /boot2dcos; \
	curl $DCOS_INSTALLER_URL | sed -e '1,/^#EOF/ s/$(pwd)\/genconf\//boot2dcos_genconf/g' > /boot2dcos/dcos_generate_config.sh;

WORKDIR /boot2dcos

COPY boot2dcos-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/boot2dcos-entrypoint.sh

ENTRYPOINT ["boot2dcos-entrypoint.sh"]