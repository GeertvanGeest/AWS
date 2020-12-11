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

### Create an ssh key pair for yourself

This key pair you can use to login with ssh to your launched instances. It will be the key pair of the user with root access. Find out [here](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html) how to do that.

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

There are three commands: `generate_credentials`, `launch_instance` and `multi_instance`. The command `multi_instance` is a wrapper of `launch_instance` to launch multiple instances from a list of users and instance names.

### Generate credentials

First, we'll have to generate credentials for the users. You can do that a while before you launch the actual instances, so you have time to send around the keys and passwords.

An example of `generate_credentials` would be:

```sh
./generate_credentials \
-l example_data/example_userlist.txt \
-o test_sepcred
```

The user list (`-l`) should contain 5 columns stating:

* First name
* Last name
* e-mail (not used now)
* Server name. The instances will be created and tagged with that name.
* Elastic IP address. You should associate only one EIP to a server name, and generate on forehand.

The rows may contain duplicate names. If the same name is associated with a single server name, it will be created only once. Otherwise, the user will be created for each separate instance. Only one password and one key will be created that can be used on all servers.

The list has to be tab delimited. Here's an example:

```
Jan	de Wandelaar	jan.wandel@somedomain.com	server1	18.198.236.145
Piet	Kopstoot	p.kopstoot@anotherdomain.ch	server1	18.198.236.145
Joop	Zoetemelk	joop.zoet@lekkerfietsen.nl	server2	3.125.31.83
```

### Launching multiple instances

Just before you need them, you can launch the instances. Make sure you have the credentials and elastic IPs ready.

A basic example of `multi_instance` would be:

```sh
./multi_instance \
-o test_sepcred \
-t t2.micro \
-a ami-0e148c450e75def48 \
-s sg-0b638dae2ff2643d2 \
-k my_key \
-p /path/to/my_key.pem
```

Here's the help documentation (`./multi_instance -h`):

```
Usage: multi_instance -a <AMI id> -s <security group> -k <key name> -p <key_file.pem> [-o <outdir>] [-t <type>] [-b <disk size>] [-d <storage device>]

 This command launches AWS instances based on a list of users and associated credentials generated with generate_credentials.

 -o work directory. Should contain output of generate_credentials (emails, password, private_keys, public_keys, users). Default: .
 -t AWS instance type. Default: t2.micro.
 -a AMI id in the format ami-xxxxxx. Required.
 -s Security group id in the format sg-xxxxxx. Required.
 -b Block size of additional disk. In gigabytes. Default: 1.
 -d Device to mount storage to. If it is the root device, it will expand it to -b. If device is non-existent, a file-system will not be created. Default: root device
 -k Key pair name. Should be available for AWS. Required.
 -p Private key file: <my_key>.pem. Should be the private key for -k. Required.
 -c Bash script with command run for all users. Default: 
 -h This helper.
```
