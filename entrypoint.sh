#!/bin/sh

if [ ! -f "/var/{txwebproject}/data" ];then
    mkdir -p /var/{txwebproject}/data
fi

exec "$@"