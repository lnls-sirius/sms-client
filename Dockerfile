FROM python:3.9.5-slim-buster AS base

ARG CLIENT_IP_ARG
ARG EPICS_URL_ARG=https://10.0.38.42/mgmt/bpl/getAllPVs?limit=-1
ARG PREFIX_ARG
ARG SERVER_IP_ARG

# ARG REPO_URL=https://github.com/SIRIUS-GOP/sms_service/tree/main
# ARG REPO_COMMIT=master

ENV CLIENT_IP ${CLIENT_IP_ARG}
ENV EPICS_URL ${EPICS_URL_ARG}
ENV PREFIX ${PREFIX_ARG}
ENV SERVER_IP ${SERVER_IP_ARG}

WORKDIR /opt

# Replace this with ADD with RUN and update the workdir to /opt/sms_service/client_venv
# RUN git clone ${REPO_URL} && git checkout ${REPO_COMMIT}
# WORKDIR /opt/sms_service/client_venv
ADD sms_service/client_venv /opt

RUN apt-get -y update && \
    apt install -y gettext-base git && \
    pip install --upgrade -r requirements.txt &&\
    pip install requests

COPY ./templates/config.cfg.tmplt ./config.cfg.tmplt

FROM base AS flask
CMD "envsubst < /opt/templates/config.cfg.tmplt > /opt/config.cfg && flask run -h ${CLIENT_IP}"

FROM base AS monitor
CMD "envsubst < /opt/templates/config.cfg.tmplt > /opt/config.cfg && python monitor.py"