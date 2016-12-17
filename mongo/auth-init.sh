#!/bin/bash
#
# auth-init.sh
# Waits for Mongo to start, then creates the initial admin and database users.
#
# Adapted from:
# https://github.com/tutumcloud/mongodb/blob/master/3.2/set_mongodb_password.sh
#

ADMIN_USER=${MONGO_ADMIN_USER:-"admin"}
ADMIN_PASS=${MONGO_ADMIN_PASS:-"admin"}

RET=1
COUNT=0

while [[ $COUNT -lt 6 && $RET -ne 0 ]]; do
	echo "=> Waiting for MongoDB service startup..."
	sleep 5
	mongo admin --eval "help" >/dev/null 2>&1
	RET=$?
	COUNT=$((COUNT+1))
done

if [[ $RET -ne 0 ]]; then
	echo "=> Failed to connect to MongoDB service"
	exit 1
fi

echo "=> Connected!"

#
# Localhost exception allows this to succeed only once
# SEE: https://docs.mongodb.com/manual/core/security-users/#localhost-exception
#
echo "=> Creating user administrator in admin database..."
mongo admin << EOF
db.createUser({user: "$ADMIN_USER", pwd: "$ADMIN_PASS", roles: [{role: "userAdminAnyDatabase", db: "admin"}]})
EOF
RET=$?

if [[ $RET -ne 0 ]]; then
	echo "=> Cannot create user administrator; probably already exists"
else
	echo "=> Success!"
fi

echo "=> Verifying user administrator in admin database..."
mongo admin -u "$ADMIN_USER" -p "$ADMIN_PASS" --authenticationDatabase "admin"
RET=$?

if [[ $RET -ne 0 ]]; then
	echo "=> Cannot authenticate user administrator"
	exit 2
fi

echo "=> Success!"

if 	[ -z "$MONGO_DB_NAME" ] || \
	[ -z "$MONGO_DB_PASS" ] || [ -z "$MONGO_DB_USER" ]; then
	exit 0
fi

echo "=> Creating user ${MONGO_DB_USER} in ${MONGO_DB_NAME} database..."
mongo -u "$ADMIN_USER" -p "$ADMIN_PASS" --authenticationDatabase "admin" << EOF
use $MONGO_DB_NAME
db.createUser({user: "$MONGO_DB_USER", pwd: "$MONGO_DB_PASS", roles: [{role: "readWrite", db: "$MONGO_DB_NAME"}]})
EOF
RET=$?

if [[ $RET -ne 0 ]]; then
	echo "=> Cannot create database user; probably already exists"
else
	echo "=> Success!"
fi
