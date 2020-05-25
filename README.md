# Deploying Flask Restful App using Docker

https://www.digitalocean.com/community/tutorials/how-to-build-and-deploy-a-flask-application-using-docker-on-ubuntu-18-04

1. Setup and create your Flask Restful App.

2. Create uwsgi.ini file
```ini
[uwsgi]
module = app ;name of your main app. e.g. app.py Remove this comment
callable = app
master = true
touch-reload = /app/uwsgi.ini
```

3. Create DockerFile
```Dockerfile
FROM tiangolo/uwsgi-nginx-flask:python3.6-alpine3.7
RUN apk --update add bash nano
ENV STATIC_URL /static
ENV STATIC_PATH /Users/asyrulhafetzy/Documents/Manchester/MSC_Project/apps/Python/FlaskApi_docker/static
COPY ./requirements.txt /Users/asyrulhafetzy/Documents/Manchester/MSC_Project/apps/Python/FlaskApi_docker/requirements.txt
RUN pip install -r /Users/asyrulhafetzy/Documents/Manchester/MSC_Project/apps/Python/FlaskApi_docker/requirements.txt
```
In this example, the Docker image will be built off an existing image, tiangolo/uwsgi-nginx-flask, which you can find on DockerHub. This particular Docker image is a good choice over others because it supports a wide range of Python versions and OS images.

The first two lines specify the parent image that you’ll use to run the application and install the bash command processor and the nano text editor. It also installs the git client for pulling and pushing to version control hosting services such as GitHub, GitLab, and Bitbucket. ENV STATIC_URL /static is an environment variable specific to this Docker image. It defines the static folder where all assets such as images, CSS files, and JavaScript files are served from.

The last two lines will copy the requirements.txt file into the container so that it can be executed, and then parses the requirements.txt file to install the specified dependencies.

4. Make sure port is available:
```bash
sudo nc localhost 56733 < /dev/null; echo $?
# should return 1
```

5. Create start.sh
```bash
#!/bin/bash
app="docker.test"
docker build -t ${app} .
docker run -d -p 56733:80 \
  --name=${app} \
  -v $PWD:/app ${app}
```
The first line is called a shebang. It specifies that this is a bash file and will be executed as commands. The next line specifies the name you want to give the image and container and saves as a variable named app. The next line instructs Docker to build an image from your Dockerfile located in the current directory. This will create an image called docker.test in this example.

The last three lines create a new container named docker.test that is exposed at port 56733. Finally, it links the present directory to the /var/www directory of the container.

You use the -d flag to start a container in daemon mode, or as a background process. You include the -p flag to bind a port on the server to a particular port on the Docker container. In this case, you are binding port 56733 to port 80 on the Docker container. The -v flag specifies a Docker volume to mount on the container, and in this case, you are mounting the entire project directory to the /var/www folder on the Docker container.


6. Execute start.sh
```bash
sudo bash start.sh
```
Your app should be available at http://localhost:56733

## Some useful commands
```bash
sudo docker ps
```

```bash
sudo docker stop docker.test && sudo docker start docker.test
```

to enable touch reload:
```bash
touch uwsgi.ini
```