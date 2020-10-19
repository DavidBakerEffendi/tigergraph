#!/bin/bash

source ./config.conf

docker build -t ${DOCKER_ACC}/${DOCKER_REPO}:${TG_VERSION} --no-cache . || exit 1
read -r -p "Would you like to push the image? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]];
then
    docker push ${DOCKER_ACC}/${DOCKER_REPO}:${TG_VERSION}
fi