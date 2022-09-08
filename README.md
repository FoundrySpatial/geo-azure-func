# geo-azure-func
Azure Functions geo gdal docker container based on the equivalent geolambda container.  

Credit to:
https://github.com/developmentseed/geolambda

# build docker image
scripts/dockerbuild.sh

# run docker image
scripts/dockerrun.sh

# debug docker image
scripts/dockershell.sh

# to test a running container
Open a browser and point to:
http://localhost:8080/api/geo_handler?filename=/vsicurl/https://download.osgeo.org/geotiff/samples/other/erdas_spnad83.tif

- Foundry Spatial team
