#!/bin/bash

WORKSPACE=$1

# get the docker
docker pull hemberglab/scrna.seq.datasets:latest
# run the docker
docker run hemberglab/scrna.seq.datasets:latest

# copy files from the last run docker container to local disk
alias dl='docker ps -l -q'
docker cp `dl`:scater-objects $WORKSPACE/
docker cp `dl`:scater-reports $WORKSPACE/

# copy results to S3
aws s3 cp scater-objects s3://scrnaseq-public-datasets/scater-objects/ --recursive
aws s3 cp scater-reports s3://scrnaseq-public-datasets/scater-reports/ --recursive

# cleanup after docker usage
docker rm `dl`
docker rmi hemberglab/scrna.seq.datasets:latest