# AWS for teaching

The commands in this repository help you to generate AWS EC2 instances for teaching.

## Step 1: Setup

### Get an AWS account

Go to [https://aws.amazon.com/](https://aws.amazon.com/) and get an account.

### Install AWS CLI

Go to [https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) for installation instructions.

### Configure your credentials for AWS CLI

Instructions from AWS [here](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html#cli-configure-files-methods).

First generate keys. To do that:

* go to the AWS console
* click on your username (topright),
* select **My Security Credentials**,
* click on **Access keys (access key ID and secret access key)**
* click on the button **Create New Access Key**

This will prompt you to download a file with access keys. Do that, and find your keys in the csv.

After that, run:

```sh
aws configure
```

and type in your specifications (check also whether you've chosen the right region):

```
AWS Access Key ID [None]: AKIAIOSFODNN7EXAMPLE
AWS Secret Access Key [None]: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
Default region name [None]: eu-central-1
Default output format [None]: json
```

### Other requirements

* Python 3 shoud be available as `python3`
* Add the repository directory to your PATH variable to have the scripts available from anywhere.

## Step 2: Create an AMI

An AMI is an image of a system. This can be used as a template for the instances you will be launching. You can prepare an AMI on a small instance (e.g. install software), store it, and use it as a template for your bigger instances. More info on AMI [here](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AMIs.html).

## Step 3: Allocate elastic IP Addresses

Allocate elastic IPs to your account. You can use these IP addresses to have a static entry point to your instances. Mere info on elastic IPs [here](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/elastic-ip-addresses-eip.html).

## Step 4: Create a security group

Create a security group to manage from which IP range and ports your instance can be approached. More info on security groups [here](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html).

## Step 5: Running the commands

There are two commands `launch_instance` and `multi_instance`. The command `multi_instance` is a wrapper of `launch_instance` to launch multiple instances from a list of users and instance names.

A basic example of `multi_instance` would be:

```sh]
./multi_instance \
-l user_list.txt \
-o ./test_output \
-t t2.micro \
-a ami-0e148c450e75def48 \
-s sg-0b638dae2ff2643d2 \
-b 1 \
-k my_key \
-p path/to/my_key.pem
```
