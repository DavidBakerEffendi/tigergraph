# TigerGraph Docker

The purpose of this repository is to create less bloated TigerGraph containers for 
resource sensitive environments e.g. CI/CD. The Docker image starts `gadmin` when
the container spins up.

The original version of the TigerGraph Docker image can be found 
[here](https://github.com/tigergraph/ecosys/tree/master/demos/guru_scripts/docker).

## Description

The Debian image is Bitnami's minideb image as the base image. This can be built
and pushed using `run.sh`. All ecosys code is not installed and some unnecessary
packages are excluded. The only text editor available is Vim but binaries like 
`wget`, `git`, `unzip`, `emacs`, etc. are removed.

## Configuration

If you would like to create and push your own version of this TigerGraph image, 
simply edit the credentials in `resources/config.conf`.
