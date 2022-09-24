FROM python:3.6.9

ENV PYTHONDONTWRITEBYTECODE 1

RUN apt-get update -qq && apt-get install -y libxmlsec1-dev

RUN mkdir /app
WORKDIR /app

COPY ./requirements.txt /app/requirements.txt
RUN pip install --upgrade pip && pip install -r /app/requirements.txt
