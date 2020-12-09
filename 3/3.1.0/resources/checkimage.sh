#!/bin/bash

# (c) 2020 TigerGraph - Bruno Šimić (bruno@tigergraph.com)
# ver 3.0.5
# at first start external data folder would be empty

# start docker-compose as deamon
INSTALL_DIR="/home/tigergraph/tigergraph"
DATA_DIR="/home/tigergraph/tigergraph/data"
INIT_DATA_FILE="/home/tigergraph/tigergraph/tmp/initdata.tgz"

# check if data folder is empty (mounted from the host!)
if find -- "$DATA_DIR" -prune -type d -empty | grep -q .; then
  cd $DATA_DIR
  tar xfz $INIT_DATA_FILE
  chown -R tigergraph:tigergraph *
fi
