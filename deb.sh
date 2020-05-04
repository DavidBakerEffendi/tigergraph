#!/bin/bash

source ./acc.conf
source ./debian-jessie/config.conf

docker build -t ${DOCKER_ACC}/${DOCKER_REPO}:${TG_VERSION}-${DEB_VERSION} ./debian-${DEB_VERSION} || exit 1
read -r -p "Would you like to push the image? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]];
then
    docker push ${DOCKER_ACC}/${DOCKER_REPO}:${TG_VERSION}-${DEB_VERSION}
fi