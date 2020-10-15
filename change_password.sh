#!/usr/bin/env bash


USER_PASSWD_LIST=$1

while read user password
  do
    echo $user:$password
  done < $USER_PASSWD_LIST

# remove users with userdel -r $user
