#!/usr/bin/env bash

USERNAME=$1
PASSWORD=$2
IP=$3

echo "Here are your credentials to logon to the AWS cloud server:

username: $USERNAME

password (only needed for Rstudio server and jupyterhub): $PASSWORD

your private key is in the attachment.

The IP of the server is: $IP

Save the key in a secure place and change the permissions to 400 (chmod 400 key_$USERNAME.pem).


This is how you login with ssh:

ssh -i /path/to/key_$USERNAME.pem $USERNAME@$IP



Rstudio server is at port 8787: http://$IP:8787

jupyterhub is at 8000: http://$IP:8000


Let me know if there are any issues.

Best,

Geert"
