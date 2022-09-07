import logging

import azure.functions as func

from osgeo import gdal


def main(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python HTTP trigger function processed a request.')

    filename = req.params.get('filename')
    if not filename:
        try:
            req_body = req.get_json()
        except ValueError:
            pass
        else:
            filename = req_body.get('filename')

    if filename:
        ds = gdal.Open(fname)
        band = ds.GetRasterBand(1)
        stats = band.GetStatistics(0, 1)
        return func.HttpResponse(stats)
    else:
        return func.HttpResponse(
             "Please pass a filename in the query string as in ../api/geo_handler?filename=sometif",
             status_code=200
        )
