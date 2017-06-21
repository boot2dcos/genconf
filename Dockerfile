FROM fedora:25

LABEL maintainer vouillaume.benjamin@gmail.com
ARG DCOS_INSTALLER_URL

ARG DOCKER_TGZ_URL="https://get.docker.com/builds/Linux/x86_64/docker-17.05.0-ce.tgz"
ENV DOCKER_TGZ_URL $DOCKER_TGZ_URL

ARG DCOS_GENERATE_CONFIG_SH="dcos_generate_config.sh"
ENV DCOS_GENERATE_CONFIG_SH $DCOS_GENERATE_CONFIG_SH

RUN set -ex; \
	curl -fSL $DOCKER_TGZ_URL -o docker.tgz; \
	tar -xzvf docker.tgz; \
	mv docker/* /usr/local/bin/; \
	rmdir docker; \
    rm docker.tgz;

ADD $DCOS_INSTALLER_URL /boot2dcos/$DCOS_GENERATE_CONFIG_SH
# Tweak DCOS install script to use the shared volume boot2dcos_genconf
RUN sed -i -e '1,/^#EOF/ s/$(pwd)\/genconf\//boot2dcos_genconf/g' /boot2dcos/$DCOS_GENERATE_CONFIG_SH

WORKDIR /boot2dcos

COPY boot2dcos-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/boot2dcos-entrypoint.sh

ENTRYPOINT ["boot2dcos-entrypoint.sh"]