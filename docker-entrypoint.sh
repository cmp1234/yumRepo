#!/bin/sh

mkdir -p /opt/yum
createrepo /opt/yum
exec "$@"
