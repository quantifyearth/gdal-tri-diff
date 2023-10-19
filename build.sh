#! /bin/sh
docker build . -f Dockerfile-3.3 -t gdal-3.3
# Reproject to metres first that both can use.
docker run --rm -v=$PWD/data:/var/data gdal-3.3 gdalwarp -s_srs "EPSG:4326" -t_srs '+proj=utm +zone=29 +datum=WGS84 +units=m +no_defs' -of GTIFF /var/data/srtm_34_11-raw.tif /var/data/srtm_34_11.tif
docker run --rm -v=$PWD/data:/var/data gdal-3.3 gdaldem tri /var/data/srtm_34_11.tif /var/data/srtm_34_11-3.3.tif

docker build . -f Dockerfile-3.2 -t gdal-3.2
docker run --rm -v=$PWD/data:/var/data gdal-3.2 gdaldem tri /var/data/srtm_34_11.tif /var/data/srtm_34_11-3.2.tif
docker run --rm -v=$PWD/data:/var/data gdal-3.2 gdal_calc.py --cal="A - B" -A /var/data/srtm_34_11-3.2.tif -B /var/data/srtm_34_11-3.3.tif --outfile=/var/data/srtm-tri-diff.tif