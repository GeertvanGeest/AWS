#!/usr/bin/env bash

USAGE="Usage: launch_instance.sh -n <name> -o <outdir> -t <type> -a <AMI id> -s <security group> -b <disk size> -e <ip allocation id> -k <key name>\n
\n
-n  user-specified instance name.\n
-o  output directory. Will be created if doesn't exist.
-t  AWS instance type e.g. t2.micro.\n
-a  AMI id in the format ami-xxxxxx.\n
-s  Security group id in the format sg-xxxxxx.\n
-b  Block size of additional disk. In gigabytes.\n
-e  Elastic ip allocation id in the format eipalloc-xxxxxxx.\n
-k  Key name. Should be available for AWS.\n
-h  This helper.\n"

while getopts ":n:o:t:a:s:b:e:k:h" opt
do
  case $opt in
    n)
      NAME=$OPTARG
      ;;
    o)
      OUTDIR=$OPTARG
      ;;
    t)
      TYPE=$OPTARG
      ;;
    a)
      AMI=$OPTARG
      ;;
    s)
      SECGROUP=$OPTARG
      ;;
    b)
      BLOCK=$OPTARG
      ;;
    e)
      ALLOCID=$OPTARG
      ;;
    k)
      KEY=$OPTARG
      ;;
    h)
      echo -e $USAGE  >&2
      exit 1
      ;;
    \?)
      echo -e "Invalid option: -$OPTARG \n" >&2
      echo -e $USAGE >&2
      exit 1
      ;;
    :)
      echo -e "Option -$OPTARG requires an argument. \n"
      echo -e $USAGE >&2
      exit 1
      ;;
  esac
done

if [ $OPTIND -eq 1 ]
then
  echo -e "No options were passed. \n" >&2
  echo -e $USAGE >&2
  exit 1
fi

if [ "$NAME" == "" ]; then echo "option -n is missing, but required">&2 && exit 1; fi
if [ "$TYPE" == "" ]; then echo "option -t is missing, but required">&2 && exit 1; fi
if [ "$AMI" == "" ]; then echo "option -a is missing, but required">&2 && exit 1; fi
if [ "$SECGROUP" == "" ]; then echo "option -s is missing, but required">&2 && exit 1; fi
if [ "$BLOCK" == "" ]; then echo "option -b is missing, but required">&2 && exit 1; fi
if [ "$ALLOCID" == "" ]; then echo "option -e is missing, but required">&2 && exit 1; fi
if [ "$KEY" == "" ]; then echo "option -k is missing, but required">&2 && exit 1; fi


# NAME=instance1 #n
# TYPE=t2.micro #t
# AMI=ami-0e148c450e75def48 #a
# SECGROUP=sg-0b638dae2ff2643d2 #s
# BLOCK=1 #b
# ALLOCID=eipalloc-0488f79057a45cdc0 #e
# KEY=key_ubuntu_gvg #k

if [ "$OUTDIR" == "" ]
then
  OUTDIR="."  
fi

mkdir -p $OUTDIR/log

echo "creating instance with type $TYPE from $AMI"

aws ec2 run-instances \
--image-id $AMI \
--count 1 \
--instance-type $TYPE \
--key-name $KEY \
--security-group-ids $SECGROUP \
--block-device-mappings "[{\"DeviceName\":\"/dev/sdf\",\"Ebs\":{\"VolumeSize\":$BLOCK,\"DeleteOnTermination\":true}}]" \
> $OUTDIR/log/$NAME.startup.json

INSTANCE=`cat $OUTDIR/log/$NAME.startup.json | python3 -c "import sys, json; print(json.load(sys.stdin)['Instances'][0]['InstanceId'])"`

echo "waiting for instance to start .. "
sleep 5

STATE=0
while [ $STATE -ne 16 ]
do
  sleep 10
  echo "checking state .. "
  aws ec2 describe-instance-status --instance-ids $INSTANCE > $OUTDIR/log/$NAME.state.json
  CONT=`grep "\"InstanceStatuses\"\: \[\]" $OUTDIR/log/$NAME.state.json`
  if [ "$CONT" == "" ]
  then
    echo "instance is running"
    STATE=`cat $OUTDIR/log/$NAME.state.json \
    | python3 -c "import sys, json; print(json.load(sys.stdin)['InstanceStatuses'][0]['InstanceState']['Code'])"`
  else
    echo "instance not running"
  fi
done

echo "Associating elastic IP .. "

aws ec2 associate-address --allocation-id $ALLOCID --instance-id $INSTANCE > $OUTDIR/log/$NAME.association.json

echo "Setting name to $NAME"

aws ec2 create-tags --resources $INSTANCE --tags Key=Name,Value=$NAME

aws ec2 describe-instances --instance-ids $INSTANCE > $OUTDIR/log/$NAME.description.json

IP=`cat $OUTDIR/log/$NAME.description.json \
| python3 -c "import sys, json; print(json.load(sys.stdin)['Reservations'][0]['Instances'][0]['PublicIpAddress'])"`

echo "Instance can be appoached at $IP with $KEY"

# generate keys & passwords
# copy scripts and keys to remote
# add users to remote
