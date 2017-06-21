#!/bin/bash
set -e

bash $DCOS_GENERATE_CONFIG_SH

#cp -R /boot2dcos/genconf/serve/* /serve/
#rm -rf dcos-* genconf/s* genconf/cl*

exec "$@"
