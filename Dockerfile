FROM python:3.9.5-slim-buster AS base

ARG CLIENT_IP_ARG
ARG EPICS_URL_ARG=https://10.0.38.42/mgmt/bpl/getAllPVs?limit=-1
ARG PREFIX_ARG
ARG SERVER_IP_ARG

ARG REPO_NAME
ARG REPO_URL
ARG REPO_COMMIT

ENV CLIENT_IP ${CLIENT_IP_ARG}
ENV EPICS_URL ${EPICS_URL_ARG}
ENV PREFIX ${PREFIX_ARG}
ENV SERVER_IP ${SERVER_IP_ARG}

RUN apt-get -y update && \
    apt install -y gettext-base git

# Replace this with ADD with RUN and update the workdir to /opt/sms_service/client_venv
RUN cd /opt && git clone ${REPO_URL} && cd ${REPO_NAME} && git checkout ${REPO_COMMIT}
WORKDIR /opt/${REPO_NAME}/client_venv

RUN pip install --upgrade -r requirements.txt &&\
    pip install requests

RUN mkdir --verbose /opt/templates
COPY ./templates/config.cfg.tmplt /opt/templates/config.cfg.tmplt

FROM base AS flask
CMD ["/bin/bash", "-c", "envsubst < /opt/templates/config.cfg.tmplt > ./config.cfg && flask run --host ${CLIENT_IP}"]

FROM base AS monitor
CMD ["/bin/bash", "-c", "envsubst < /opt/templates/config.cfg.tmplt > ./config.cfg && python monitor.py"]