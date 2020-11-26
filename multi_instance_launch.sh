#!/usr/bin/env bash

USAGE="Usage: multi_instance_launch.sh -l <user list> -o <outdir> -t <type> -a <AMI id> -s <security group> -b <disk size> -k <key name> -p <key_file.pem>\n
\n
This command launches AWS instances based on a list of users.\n
It assigns an elastic IP to an instance. Therefore, make sure there are enough available \n
elastic IPs associated with your AWS account.\n
\n
-l  tab-delimited list of users, with 4 columns: first name, last name, e-mail, instance name. NOTE: remove any spaces in the names. \n
-o  output directory. Will be created if doesn't exit.\n
-t  AWS instance type e.g. t2.micro.\n
-a  AMI id in the format ami-xxxxxx.\n
-s  Security group id in the format sg-xxxxxx.\n
-b  Block size of additional disk. In gigabytes.\n
-k  Key name. Should be available for AWS.\n
-p  Private key file: <my_key>.pem.\n
-h  This helper.\n"

while getopts ":l:o:t:a:s:b:k:p:h" opt
do
  case $opt in
    l)
      LIST=$OPTARG
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
    k)
      KEY=$OPTARG
      ;;
    p)
      PEM=$OPTARG
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

if [ "$LIST" == "" ]; then echo "option -l is missing, but required">&2 && exit 1; fi
if [ "$TYPE" == "" ]; then echo "option -t is missing, but required">&2 && exit 1; fi
if [ "$AMI" == "" ]; then echo "option -a is missing, but required">&2 && exit 1; fi
if [ "$SECGROUP" == "" ]; then echo "option -s is missing, but required">&2 && exit 1; fi
if [ "$BLOCK" == "" ]; then echo "option -b is missing, but required">&2 && exit 1; fi
if [ "$KEY" == "" ]; then echo "option -k is missing, but required">&2 && exit 1; fi
if [ "$PEM" == "" ]; then echo "option -p is missing, but required">&2 && exit 1; fi

if [ "$OUTDIR" == "" ]
then
  OUTDIR=.
fi

for dir in private_keys public_keys emails passwords
do
  mkdir -p $OUTDIR/$dir
done

INSTANCE_NAMES=`cut -f 4 $LIST | sort | uniq | sed 's/\r//g'`

for NAME in $INSTANCE_NAMES
do
  # get first available allocation id:
  ALLOCID=`aws ec2 describe-addresses --query 'Addresses[?InstanceId==null]' \
  | python3 -c "import sys, json; print(json.load(sys.stdin)[0]['AllocationId'])"`

  ./launch_instance.sh -n $NAME -o $OUTDIR -t $TYPE -a $AMI -s $SECGROUP -b $BLOCK -e $ALLOCID -k $KEY

  IP=`cat $OUTDIR/log/$NAME.description.json \
  | python3 -c "import sys, json; print(json.load(sys.stdin)['Reservations'][0]['Instances'][0]['PublicIpAddress'])"`


  FIRSTL=`grep "$NAME" "$LIST" | cut -f 1 | tr -cd '\11\12\15\40-\176' | tr [:upper:] [:lower:] | cut -c-1`
  LASTN=`grep "$NAME" "$LIST" | cut -f 2 | tr -cd '\11\12\15\40-\176' | tr [:upper:] [:lower:]`

  USERNAMES=$(paste -d '-' <(echo "$FIRSTL") <(echo "$LASTN") | tr -d '-' | sed 's/\r//g')

  echo "" > $OUTDIR/passwords/passwords_"$NAME".txt

  for user in $USERNAMES
  do
    password=`openssl rand -base64 14`
    echo -e $user"\t"$password >> $OUTDIR/passwords/passwords_"$NAME".txt
    ./generate_mail.sh $user $password $IP > $OUTDIR/emails/mail_$user.txt
    ./generate_keys.sh $user $OUTDIR/private_keys $OUTDIR/public_keys
  done

  echo "waiting 60 seconds to start up .."
  sleep 60

  ssh-keygen -R $IP
  scp -o StrictHostKeyChecking=accept-new -i $PEM -r $OUTDIR/public_keys ubuntu@"$IP":/home/ubuntu
  scp -i $PEM add_users.sh ubuntu@"$IP":/home/ubuntu
  scp -i $PEM $OUTDIR/passwords/passwords_"$NAME".txt ubuntu@"$IP":/home/ubuntu

  ssh -i $PEM ubuntu@"$IP" "sudo ./add_users.sh passwords_"$NAME".txt condausers /home/ubuntu/public_keys"

done
