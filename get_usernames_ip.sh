#!/usr/bin/env bash
USER_LIST=$1 # tab delimited file with "first name", "last name", "ip"

FIRSTL=`cut -f 1 $USER_LIST | tr -cd '\11\12\15\40-\176' | tr [:upper:] [:lower:] | cut -c-1`
LASTN=`cut -f 2 $USER_LIST | tr -cd '\11\12\15\40-\176' | tr [:upper:] [:lower:]`

USERNAMES=$(paste -d '-' <(echo "$FIRSTL") <(echo "$LASTN") | tr -d '-')

IP=`cut -f 3 $USER_LIST`

paste <(echo $USERNAMES | tr " " "\n") <(echo $IP | tr " " "\n")
