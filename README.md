# TigerGraph Docker

The purpose of this repository is to create less bloated TigerGraph containers for 
resource sensitive environments e.g. CI/CD. The Docker image starts `gadmin` when
the container spins up.

The original version of the TigerGraph Docker image can be found 
[here](https://github.com/tigergraph/ecosys/tree/master/demos/guru_scripts/docker).

For a detailed tutorial on how this image works, please read [my article on Medium](https://towardsdatascience.com/efficient-use-of-tigergraph-and-docker-5e7f9918bf53).

## Description

The Debian image is Bitnami's minideb image as the base image. This can be built
and pushed using `run.sh`. All ecosys code is not installed and some unnecessary
packages are excluded. The only text editor available is Vim but binaries like 
`wget`, `git`, `unzip`, `emacs`, etc. are removed.

Each directory found in this repository correlate to the tag under each image on the
[DockerHub](https://hub.docker.com/repository/docker/dbakereffendi/tigergraph).

## Running Scripts at Startup

If you have a GSQL script to run at startup you can bind it to `docker-entrypoint-initdb.d` 
using Docker volumes. All scripts suffixed with `.gsql` will be executed by the `gsql` command by user `tigergraph`.

## Configuration

If you would like to create and push your own version of this TigerGraph image, 
simply edit the credentials in `resources/config.conf`.
