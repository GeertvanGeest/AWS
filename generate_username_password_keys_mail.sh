#!/usr/bin/env bash

USER_LIST=$1 # tab delimited file with "first name", "last name", "ip"
PRIVATE_KEY_DIR=$2
PUBLIC_KEY_DIR=$3
MAIL_DIR=$4

<<<<<<< HEAD
FIRSTL=`cut -f 1 $USER_LIST | tr -cd '\11\12\15\40-\176' | tr [:upper:] [:lower:] | cut -c-1`
LASTN=`cut -f 2 $USER_LIST | tr -cd '\11\12\15\40-\176' | tr [:upper:] [:lower:] | tr -d [:space:]`
=======
./get_usernames_ip.sh $USER_LIST > usernames_ip.txt
>>>>>>> 854b81a94fcd7ff5289b91fb92fe6a1b798838d8

while read user ip
do
  password=`openssl rand -base64 14`
  echo -e $user"\t"$password"\t"$ip >> username_pw_ip.txt
  ./generate_mail.sh $user $password $ip > $MAIL_DIR/mail_$user.txt
  ./generate_keys.sh $user $PRIVATE_KEY_DIR $PUBLIC_KEY_DIR
done < usernames_ip.txt
