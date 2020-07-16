#!/usr/bin/env bash

## run as root
## sudo su -

groupadd $2

while read user
  do
    adduser \
    --gecos "" \
    --disabled-password \
    $user

    adduser \
    $user \
    $2 \

    cd /home/$user
    mkdir .ssh
    chmod 700 .ssh
    touch .ssh/authorized_keys
    chmod 600 .ssh/authorized_keys
    cat /home/ubuntu/public_keys/key_$user.pub >> .ssh/authorized_keys
    chown -R $user .ssh
  done < $1

# remove users with userdel -r $user
