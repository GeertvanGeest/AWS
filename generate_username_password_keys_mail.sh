#!/usr/bin/env bash

USER_LIST=$1
PRIVATE_KEY_DIR=$2
PUBLIC_KEY_DIR=$3
IP=$4
MAIL_DIR=$5

FIRSTL=`cut -f 1 $USER_LIST | tr -cd '\11\12\15\40-\176' | tr [:upper:] [:lower:] | cut -c-1`
LASTN=`cut -f 2 $USER_LIST | tr -cd '\11\12\15\40-\176' | tr [:upper:] [:lower:] | tr -d [:space:]`

USERNAMES=$(paste -d '-' <(echo "$FIRSTL") <(echo "$LASTN") | tr -d '-')

for user in $USERNAMES
do
  password=`openssl rand -base64 14`
  echo -e $user"\t"$password
  ./generate_mail.sh $user $password $IP > $MAIL_DIR/mail_$user.txt
  ./generate_keys.sh $user $PRIVATE_KEY_DIR $PUBLIC_KEY_DIR
done
