#!/usr/bin/env bash

USER_LIST=$1 # tab delimited file with "first name", "last name", "ip"
PRIVATE_KEY_DIR=$2
PUBLIC_KEY_DIR=$3
MAIL_DIR=$4

./get_usernames_ip.sh $USER_LIST > usernames_ip.txt

while read user ip
do
  password=`openssl rand -base64 14`
  echo -e $user"\t"$password"\t"$ip > username_pw_ip.txt
  ./generate_mail.sh $user $password $ip > $MAIL_DIR/mail_$user.txt
  ./generate_keys.sh $user $PRIVATE_KEY_DIR $PUBLIC_KEY_DIR
done < usernames_ip.txt
