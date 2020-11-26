#!/usr/bin/env bash

./multi_instance_launch.sh \
-l user_list.txt \
-o ./test_output \
-t t2.micro \
-a ami-0e148c450e75def48 \
-s sg-0b638dae2ff2643d2 \
-b 1 \
-k key_ubuntu_gvg \
-p ./AWS_credentials_SIB/key_ubuntu_gvg.pem
