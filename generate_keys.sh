#!/bin/bash

while read user
  do
    aws ec2 create-key-pair \
    --key-name key_$user \
    --query 'KeyMaterial' \
    --output text \
    > private_keys/key_$user.pem

    chmod 400 key_$user.pem

    ssh-keygen \
    -y -f key_$user.pem \
    > public_keys/key_$user.pub
  done < $1
