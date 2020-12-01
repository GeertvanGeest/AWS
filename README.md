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

Here's the help documentation (`./multi_instance -h`):

```
Usage: multi_instance_launch.sh -l <user list> -a <AMI id> -s <security group> -k <key name> -p <key_file.pem> [-o <outdir>] [-t <type>] [-b <disk size>]

 This command launches AWS instances based on a list of users.
 It assigns an elastic IP to an instance. Therefore, make sure there are enough available
 elastic IPs associated with your AWS account.

 -l tab-delimited list of users, with 4 columns: first name, last name, e-mail, instance name. Required.
 -o output directory. Will be created if doesn't exist. Default: .
 -t AWS instance type. Default: t2.micro.
 -a AMI id in the format ami-xxxxxx. Required.
 -s Security group id in the format sg-xxxxxx. Required.
 -b Block size of additional disk. In gigabytes. Default: 1.
 -k Key pair name. Should be available for AWS. Required.
 -p Private key file: <my_key>.pem. Should be the private key for -k. Required.
 -h This helper.
```

The user list (`-l`) should contain 4 columns stating:

* First name
* Last name
* e-mail (not used now)
* Server name. The instances will be created and tagged with that name.

The rows may contain duplicate names with different servers. This means that for each instance that user will be created. Only one password and one key will be created that can be used on all servers.

The list has to be tab delimited. Here's an example:

```
Jan     de Wandelaar    jan.wandel@somedomain.com       server1
Piet    Kopstoot        p.kopstoot@anotherdomain.ch     server1
Joop    Zoetemelk       joop.zoet@lekkerfietsen.nl      server2
```
