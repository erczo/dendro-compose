#!/bin/bash
#
# auth-entrypoint.sh
# Docker entrypoint script; used from a compose file to prepare the Mongo database.
#

set -e

if [ "$1" = 'mongod' ]; then
	shift 1
	./auth-init.sh &
	./entrypoint.sh mongod --auth $@
else
	./entrypoint.sh $@
fi
