#!/bin/sh

# install requirements.txt
python3 -m pip install -r /django/requirements.txt

# collect static
if $AUTO_COLLECT
then
  python3 /django/manage.py collectstatic --noinput
fi
# run server
python3 /django/manage.py runserver $IP_PORT