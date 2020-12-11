#!/usr/bin/env bash

./generate_credentials \
-o test_deploy \
-l example_data/example_userlist.txt

./multi_instance \
-o test_deploy \
-a ami-0502e817a62226e03 \
-s sg-0b638dae2ff2643d2 \
-b 8 \
-k my_key \
-c example_data/test_user_script.sh \
-p /path/to/my_key.pem

# ssh -i /Users/geertvangeest/CloudStation/Werk/SIB/AWS/AWS_credentials_SIB/key_ubuntu_gvg.pem ubuntu@
