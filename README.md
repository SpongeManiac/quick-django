# Quick-Django
Quickly serve a Django project as a Docker container and allow live development

# Use
To use `quick-django`, you will need to prepare a workspace and your django project.

## Workspace Prep
Find a suitable place to serve your django project and static files as `www-data` user. In this guide, we will use the path `/var/django/myproject`. Where you put your project and static files does not matter, however you will need to ensure permissions are properly configured along with other configs to reflect these locations. 

Start by creating some directories (We will set proper permissions later):
```shell
sudo mkdir -p /var/django/myproject/app; sudo mkdir /var/django/myproject/static
```
Copy or move your project files:
```shell
sudo mv /home/myuser/myproject/* /var/django/myproject/app
```
You should end up with a layout similar to this:
```
/var/
├─ django/
│  ├─ myproject/
│  │  ├─ app/
│  │  │  ├─ myproject/
│  │  │  │  ├─ settings.py
│  │  │  ├─ manage.py
│  │  │  ├─ db.sqlite3
│  │  ├─ static/
```

## Project Prep
Now we will change a couple of things in your project:
1. Ensure `STATIC_ROOT` path reflects the static path within the Docker container:

_/var/django/myproject/app/myproject/settings.py_
```python
...

STATIC_ROOT = '/var/www/static'

...
```
`NOTE:`

Be sure to config your webserver/reverse proxy to serve static files from `/var/django/myproject/static`

2. `requirements.txt` file is present in your project's `app` directory:

_/var/django/myproject/app_
```shell
pip freeze > requirements.txt
```

You should now have a `requirements.txt` file like so:
```
/var/
├─ django/
│  ├─ myproject/
│  │  ├─ app/
|  |  |  ├─ myproject/
│  │  │  ├─ manage.py
│  │  │  ├─ db.sqlite3
|  |  |  ├─ requirements.txt
```

## Set Permissions
Now we can set proper permissions for `www-data` user:
```shell
sudo chown -R www-data:www-data /var/django; sudo chmod -R 775 /var/django
```

# Docker Setup
Now we can begin to set up the docker container.

Pull docker image:

```shell
sudo docker pull spongemaniac/quick-django
```

Create a docker compose config:

_myconfig.yml_
```yml
services:
  myproject:
    image: spongemaniac/quick-django
    container_name: myproject
    restart: always
    # If you want to expose container ports on host
    ports:
      # IP:HOST_PORT:DOCKER_PORT
      - "127.0.0.1:8000:8080"
    volumes:
      # Django project files
      - /var/django/myproject/app:/django
      # Django static files
      - /var/django/myproject/static:/var/www/static
    environment:
      # IP and port django will serve on
      - IP_PORT=0.0.0.0:8080
      # Whether to automatically collect static on start
      - AUTO_COLLECT=true
```

# Start Container
Finally, we can start the container:
```shell
sudo docker compose -f myconfig.yml up --detach
```

You should now be able to access your django project on port `8000` if you opened the port on the host. You can now develop and take advantage of hot-reloading while serving your project in a docker container.
