#!/bin/bash

#
# not yet production ready, therefore let us exit here.
exit 0

# REMEMBER docker@nautlus has disabled auto-iptables.

# Some docker run call for nextcloud-server
# 1st build it in the dir of the Dockerfile
docker build -t nc .


# Afterwards we are able to run this nextcloud
#
# -e ENV-Vars of this image, see README.md (no ENV-Vars, yet)
# -v connect persistent volume for data storage
# -p publish the network port (80,443)
# -d dettach terminal
docker run --name nextcloud \
	-v ~/work/NC16containerized/nginx/persistent:/opt/nextcloud/data \
	-p 80:80 -p 443:443 \
	nc:latest


	

