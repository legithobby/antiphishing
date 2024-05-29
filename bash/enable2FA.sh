#!/usr/bin/env bash
# This script removes nft rule to Openwrt routers nft 'inet fw4' table forward chain
source ./router.creds
WIFITAB_IP="192.168.1.100"
TABLE="inet fw4"
CHAIN="forward"

COMMANDS="nft -a list chain $TABLE $CHAIN | awk '/ip saddr ${WIFITAB_IP} drop /{print \$(NF)}'"

RULENR=$(ssh -p $PORT $USER@$ROUTER "$COMMANDS")

# Check if $RULENR is empty which means no nft rule was found
if [ -z "$RULENR" ]
then
  exit
fi

DELCOMMANDS="nft delete rule $TABLE $CHAIN handle $RULENR"

ssh -p $PORT $USER@$ROUTER "$DELCOMMANDS"

