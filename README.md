# Manage users and credentials for AWS server

## Step 1: generate credentials and mails

Make sure that:
* `generate_keys.sh`, `generate_mails.sh`, and `generate_username_password_keys_mail.sh` are in the same directory
* AWS CLI is installed and configured

The wrapper below generates usernames, passwords, keys and e-mails. It writes usernames and associated passwords to stdout.

```sh
generate_username_password_keys_mail.sh \
USERLIST \
PATH/TO/PRIVATE_KEY_DIR \
PATH/TO/PUBLIC_KEY_DIR \
PATH/TO/MAIL_OUTPUT
```

## Step 2: add users on the server

Generate the users on the server itself. Copy the scripts `add_users.sh` and the generated public keys to the server.


```sh
sudo su
add_users.sh \
USER_PASSWD_LIST \
GROUP \
PATH/TO/PUBLIC_KEYS
```
