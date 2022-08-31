# geo-azure-func
Azure Functions docker container equivalent of geolambda container

# build docker image
docker build --tag geo-azure-func:latest .

# run docker image
docker run --name geo-azure-func -w /var/task --volume $(shell pwd)/:/local -itd geo-azure-func:latest bash

