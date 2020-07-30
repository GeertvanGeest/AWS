#!/bin/bash

USER=$1
PRIVATE_KEY_DIR=$2
PUBLIC_KEY_DIR=$3

## run this at personal computer with AWS CLI installed

aws ec2 create-key-pair \
--key-name key_$USER \
--query 'KeyMaterial' \
--output text \
> $PRIVATE_KEY_DIR/key_$USER.pem

chmod 400 $PRIVATE_KEY_DIR/key_"$USER".pem

ssh-keygen \
-y -f $PRIVATE_KEY_DIR/key_"$USER".pem \
> $PUBLIC_KEY_DIR/key_$USER.pub
