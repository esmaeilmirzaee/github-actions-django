FROM python:3.10.7-alpine3.16
LABEL maintainer="lexu.com"

ENV PYTHONUNBUFFERED 1

RUN adduser \
      -D djangouser

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app/ /app/
WORKDIR /app/
EXPOSE 8000

ARG DEV=false
RUN python -m venv /py && \
        /py/bin/pip install --upgrade pip && \
        /py/bin/pip install -r /tmp/requirements.txt && \
        if [ $DEV="true" ]; \
          then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
        fi && \
    rm -rf /tmp

RUN chown djangouser:djangouser -R /home/
RUN chown djangouser:djangouser -R /app/
RUN ls -ashl /home/

USER djangouser

ENV PATH="/py/bin:$PATH"