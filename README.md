# TigerGraph Docker

The purpose of this repository is to create less bloated TigerGraph containers for 
resource sensitive environments e.g. CI/CD. The Docker image starts `gadmin` when
the container spins up.

The original version of the TigerGraph Docker image can be found [here](https://github.com/tigergraph/ecosys/tree/master/demos/guru_scripts/docker).
If you would like to create and push your own version of a TigerGraph image, simply edit the credentials in `config.conf`.

## Debian Jessie

`Dockerfile-jessie` uses Bitnami's minideb image as base which sits at around 50mb.
This can be build and pushed using `deb.sh`.