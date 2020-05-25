FROM tiangolo/uwsgi-nginx-flask:python3.6-alpine3.7
RUN apk --update add bash nano
ENV STATIC_URL /static
ENV STATIC_PATH /Users/asyrulhafetzy/Documents/Manchester/MSC_Project/apps/Python/FlaskApi_docker/static
COPY ./requirements.txt /Users/asyrulhafetzy/Documents/Manchester/MSC_Project/apps/Python/FlaskApi_docker/requirements.txt
RUN pip install -r /Users/asyrulhafetzy/Documents/Manchester/MSC_Project/apps/Python/FlaskApi_docker/requirements.txt