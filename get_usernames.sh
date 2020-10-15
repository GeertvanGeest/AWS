USER_LIST=$1

FIRSTL=`cut -f 1 $USER_LIST | tr -cd '\11\12\15\40-\176' | tr [:upper:] [:lower:] | cut -c-1`
LASTN=`cut -f 2 $USER_LIST | tr -cd '\11\12\15\40-\176' | tr [:upper:] [:lower:]`

USERNAMES=$(paste -d '-' <(echo "$FIRSTL") <(echo "$LASTN") | tr -d '-')

for user in $USERNAMES
do
  echo $user
done
