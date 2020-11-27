#!/usr/bin/env bash

## usage: add_users.sh USER_LIST GROUP KEY_DIR
## run as root
## sudo su -

USER_PASSWD_LIST=$1
GROUP=$2
PUBLIC_KEY_DIR=$3 ## use full path!

groupadd $GROUP

while read user password
  do
    adduser \
    --gecos "" \
    --disabled-password \
    $user

    adduser \
    $user \
    $GROUP \

    echo $user:$password | chpasswd

    cd /home/$user
    mkdir .ssh
    chmod 700 .ssh
    touch .ssh/authorized_keys
    chmod 600 .ssh/authorized_keys
    cat $PUBLIC_KEY_DIR/key_$user.pub >> .ssh/authorized_keys
    chown -R $user .ssh
  done < $USER_PASSWD_LIST

# remove users with userdel -r $user
