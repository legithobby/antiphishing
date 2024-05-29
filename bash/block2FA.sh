#!/usr/bin/env bash
# This script adds nft rule to Openwrt routers nft 'inet fw4' table forward chain
source ./router.creds
WIFITAB_IP="192.168.1.100"
TABLE="inet fw4"
CHAIN="forward"

COMMANDS="nft insert rule $TABLE $CHAIN ip saddr $WIFITAB_IP drop"

ssh -p $PORT $USER@$ROUTER "$COMMANDS"


