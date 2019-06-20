#!/bin/bash

#
# not yet production ready, therefore let us exit here.
exit 0

# REMEMBER docker@nautlus has disabled auto-iptables.
# Therefore had to do masquerade with nftables. see /etc/nftables-nat.nft

# Some docker run call for redis-server
# 1st build it in the dir of the Dockerfile
docker build -t redis .

# Afterwards we are able to run this redis
#
# -e ENV-Vars of this image, see README.md
# -v connect persistent volume for database storage
# -p publish the network port 
# -D detach from stdout
docker run --name redis-server \
	-e ALLOW_EMPTY_PASSWORD=yes \
	-v ~/work/NC16containerized/redis/persistent:/bitnami/redis/data \
	redis:latest

#example:
docker run --name redis-server -e ALLOW_EMPTY_PASSWORD=yes redis

#example client
docker run -it redis redis-cli -h 172.17.0.3

