FROM python:3.9.5-slim-buster AS base

ARG CLIENT_IP_ARG
ARG EPICS_URL_ARG=https://10.0.38.42/mgmt/bpl/getAllPVs?limit=-1
ARG PREFIX_ARG
ARG SERVER_IP_ARG

ENV CLIENT_IP ${CLIENT_IP_ARG}
ENV EPICS_URL ${EPICS_URL_ARG}
ENV PREFIX ${PREFIX_ARG}
ENV SERVER_IP ${SERVER_IP_ARG}

WORKDIR /opt

ADD sms_service/client_venv /opt

RUN apt-get -y update && \
    apt install -y gettext-base && \
    pip install --upgrade -r requirements.txt

ADD ./templates /opt/templates

FROM base AS flask
CMD "envsubst < /opt/templates/config.cfg.tmplt > /opt/config.cfg && flask run -h ${CLIENT_IP}"

FROM base AS monitor
CMD "envsubst < /opt/templates/config.cfg.tmplt > /opt/config.cfg && python monitor.py"