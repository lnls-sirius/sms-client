#!/bin/sh
set -exu

DOCKER_REGISTRY=docker.io
DOCKER_USER_GROUP=lnls
DOCKER_IMAGE_PREFIX=${DOCKER_REGISTRY}/${DOCKER_USER_GROUP}

# Generic
AUTHOR="GAS group"
BRANCH=$(git branch --no-color --show-current)
BUILD_DATE=$(date -I)
BUILD_DATE_RFC339=$(date --rfc-3339=seconds)
COMMIT=$(git rev-parse --short HEAD)
DEPARTMENT=GAS
REPOSITORY=$(git remote show origin |grep Fetch|awk '{ print $3 }')
VENDOR="CNPEM"

# Repo
REPO_NAME="sms_service"
REPO_URL="https://github.com/SIRIUS-GOP/${REPO_NAME}"
REPO_COMMIT="main"

# -----------------------------------------------------------------
BUILD_ENVS="\
    BRANCH=${BRANCH} \
    BUILD_DATE=${BUILD_DATE} \
    COMMIT_HASH=${COMMIT} \
    DEPARTMENT=${DEPARTMENT} \
    DOCKER_IMAGE_PREFIX=${DOCKER_IMAGE_PREFIX} \
    REPOSITORY=${REPOSITORY} \
    REPO_COMMIT=${REPO_COMMIT} \
    REPO_NAME=${REPO_NAME} \
    REPO_URL=${REPO_URL} \
    VENDOR=${VENDOR}"

if [ -f .env ]; then
    > .env
    echo AUTHOR=${AUTHOR} >> .env
    echo BUILD_DATE_RFC339=${BUILD_DATE_RFC339} >> .env
    for var in ${BUILD_ENVS}; do
        echo ${var} >> .env
    done
fi
