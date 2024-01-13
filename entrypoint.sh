#!/bin/sh

# install requirements.txt
python3 -m pip install -r /django/requirements.txt

# collect static
if $AUTO_COLLECT
then
  python3 /django/manage.py collectstatic --noinput
fi

if $CUSTOM_ENTRY
then
  echo "custom"
  eval $ENTRY
else
  echo "python3"
  python3 /django/manage.py runserver $IP_PORT
fi
