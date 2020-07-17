#!/usr/bin/env bash

## usage: add_users.sh USER_LIST GROUP OUTPUT
## run as root
## sudo su -

groupadd $2

while read user
  do
    password=`openssl rand -base64 14`
    # echo "user:" $user
    # echo "password:" $password

    echo -e $user'\t'$password >> $3

    adduser \
    --gecos "" \
    --disabled-password \
    $user

    adduser \
    $user \
    $2 \

    echo $user:$password | chpasswd

    cd /home/$user
    mkdir .ssh
    chmod 700 .ssh
    touch .ssh/authorized_keys
    chmod 600 .ssh/authorized_keys
    cat /home/ubuntu/public_keys/key_$user.pub >> .ssh/authorized_keys
    chown -R $user .ssh
  done < $1

# remove users with userdel -r $user
