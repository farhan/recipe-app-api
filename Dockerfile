FROM python:3.7-alpine
MAINTAINER Muhammad Farhan Khan

ENV PYTHONBUFFERED 1

# Install dependencies
COPY ./requirements.txt /requirements.txt
RUN apk add --update --no-cache postgresql-client jpeg-dev
RUN apk add --update --no-cache --virtual .tmp-build-deps \
      gcc libc-dev linux-headers postgresql-dev musl-dev zlib zlib-dev
RUN pip install -r /requirements.txt
RUN apk del .tmp-build-deps

RUN mkdir /app
WORKDIR /app
COPY ./app /app

# Create folders for media and static files
RUN mkdir -p /vol/web/media
RUN mkdir -p /vol/web/static
RUN adduser -D user
# Give 'vol' folder and its subfolders permissions (-R recusively) to user
RUN chown -R user:user /vol/
RUN chmod -R 755 /vol/web
USER user
