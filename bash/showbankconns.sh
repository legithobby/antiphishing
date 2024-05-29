#!/usr/bin/env bash
bankaddrlist="./bankaddrlist.txt"

# Block wifitable internet access
./block2FA.sh

newline=$'\n'
while IFS= read -r line
do
  if [[ "$line" != '' ]]
  then
    bankip=$(dig +short "$line")
    # Banks ip addresses are concatenated in one line, space separated
    bankipstring+="$bankip "
    for iipee in $(echo "$bankip")
    do
      ipanddomain+="Domain name: $line   IP address: $iipee$newline"
    done
  fi  
done < "$bankaddrlist"

findinstring () {
  item=$1
  longstring=$2
  hit=$(echo $longstring | grep -o "$item")
  echo $hit
}

while true
do
  servers=$(ss -tn4 | tail -n +2 | grep -v '0.0.0.0' | awk '{print $5}' | cut -d ':' -f1 | sort | uniq)
  for serv in $(echo $servers)
  do 
    hit=''
    hit=$(findinstring $serv "$bankipstring")
    if [[ "$hit" != '' ]]
    then
      # Allow wifi tablet internet access so that it can be used for 2FA
      ./enable2FA.sh
      infotxt=$( echo "$ipanddomain" | grep $hit )
      zenity --info --text="$infotxt" --title="Bank connection found"
      echo $infotxt
    fi
  done
  sleep 1
done

