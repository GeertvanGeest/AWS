#!/usr/bin/env bash

USERNAME=$1
PASSWORD=$2
IP=$3

echo "In this e-mail you will find your personal credentials required for your upcoming course. 

We will use these credentials to log in to a remote server. 

username: $USERNAME

password (only needed for web applications): $PASSWORD

your private key is in the attachment.

The IP of the server is: $IP

For Linux/macOS users:

Save the key in a secure place and change the permissions to 400 (chmod 400 key_$USERNAME.pem).

You can login with: ssh -i /path/to/key_$USERNAME.pem $USERNAME@$IP

For Windows users: use MobaXterm to login with the private key.

The remote server will be available at the start of the course.
"
