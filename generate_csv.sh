#!/bin/bash

set -e

KEYS_FILE=$1
EMAILS_FILE=$2

SENDER_NAME="<YOUR_NAME>"
GAME_NAME="<GAME_NAME>"

LINE_BREAK="%0D%0A"

if [[ -z $KEYS_FILE ]] || [[ -z $EMAILS_FILE ]] ; then
    echo 'Usage: ./generate_csv.sh [keys_file] [emails_csv]' >/dev/stderr
    exit 1
fi

get_line()
{
    FILE=$1
    LINE_INDEX=$2

    head -n$(($LINE_INDEX + 1)) $FILE | tail -1
}

get_key()
{
    get_line $KEYS_FILE $1
}

get_name()
{
    get_line $EMAILS_FILE $1 | cut -d ',' -f1
}

get_email()
{
    get_line $EMAILS_FILE $1 | cut -d ',' -f2
}

get_email_body()
{
    echo "Hello $1,${LINE_BREAK}${LINE_BREAK}Here is your $GAME_NAME key: $2.${LINE_BREAK}${LINE_BREAK}Cheers,${LINE_BREAK}$SENDER_NAME"
}

i=0
while [[ $i -lt $(wc -l $EMAILS_FILE | awk '{ print $1 }') ]] ; do
#
# done
#
# for line in $(wc -l $EMAILS_FILE) ; do
    # get_key $i

    key=$(get_key $i)
    email=$(get_email $i)
    name=$(get_name $i)
    subject="Your $GAME_NAME key"
    body=$(get_email_body "$name" "$key")

    echo "=HYPERLINK(\"mailto:$email?subject=$subject&body=$body\")"

    i=$(($i + 1))
done

exit 0
