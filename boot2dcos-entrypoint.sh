#!/bin/bash
set -e

bash dcos_generate_config.sh

exec "$@"
