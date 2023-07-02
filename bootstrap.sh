#!/bin/bash

env | sed -r "s/'/\\\'/gm" | sed -r "s/^([^=]+=)(.*)\$/\1'\2'/gm" > /etc/environment

/usr/local/sbin/bootstrap