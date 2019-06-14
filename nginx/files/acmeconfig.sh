#!/bin/bash

NC_FQDN="nc.dtx.at nextcloud.dtx.at"
ACMETOOL=$(which acmetool)

$ACMETOOL want $NC_FQDN

