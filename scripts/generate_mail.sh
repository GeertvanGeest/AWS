#!/usr/bin/env bash

USERNAME=$1
PASSWORD=$2
IP=$3

echo "Here are your credentials to logon to the AWS cloud server:

username: $USERNAME

password (only needed for web applications): $PASSWORD

your private key is in the attachment.

The IP of the server is: $IP

For Linux/macOS users:

Save the key in a secure place and change the permissions to 400 (chmod 400 key_$USERNAME.pem).

ssh -i /path/to/key_$USERNAME.pem $USERNAME@$IP

For Windows users: use MobaXterm to login with the private key.

The remote server will be available at the start of the course.

"
