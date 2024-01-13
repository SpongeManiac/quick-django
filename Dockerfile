#use alpine-www
FROM spongemaniac/alpine-www

#django app directory
VOLUME /django
#django static root
VOLUME /var/www/static

#ip and port to run django on
ENV IP_PORT=0.0.0.0:8080
#static files directory path inside of project
ENV STATIC_DIR=static
#collect static files on start
ENV AUTO_COLLECT=false

#install dependencies
RUN apk add --update --no-cache python3

ADD entrypoint.sh /var/www/
RUN chmod +x /var/www/entrypoint.sh

#change user
USER www-data

#ensure pip is installed & upgraded
RUN python3 -m ensurepip
RUN python3 -m pip install --no-cache --upgrade pip

# Run server
ENTRYPOINT ["/var/www/entrypoint.sh"]
