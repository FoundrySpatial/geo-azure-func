import logging

import azure.functions as func

from osgeo import gdal


def main(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python HTTP trigger function processed a request.')

    filename = ''.join(req.params.get('filename'))
    if not filename:
        try:
            req_body = req.get_json()
        except ValueError:
            pass
        else:
            filename = req_body.get('filename')

    if filename:
        logging.info ('\n>>>>>>> received request to open filename(' + filename + ')')
        ds = gdal.Open(filename)
        band = ds.GetRasterBand(1)
        stats = band.GetStatistics(0, 1)
        retstats = ' '.join([str(x) for x in stats])
        return func.HttpResponse(retstats)
    else:
        return func.HttpResponse(
             "Please pass a filename in the query string as in ../api/geo_handler?filename=sometif",
             status_code=200
        )
