res=$1 # resolution in meters
path=$2
finaloutpath=$3

startyear=1
endyear=1

# extract year rasters and resample to target resolution
for yearidx in {1..1}
do
    echo $yearidx
    echo "Try this with .vrt"
    inpath=$path
    outpath=/tmp/tmp.tif
    #python ~/code/oss/gdal_calc.py --co="COMPRESS=LZW" -A $inpath --outfile $outpath --calc="A==$yearidx" --overwrite

    echo "Warping"
    inpath=$outpath
    outpath=/tmp/tmp_avg.tif
    gdalwarp -r average -srcnodata 255 -dstnodata 233 -overwrite $inpath $outpath -tr $res $res

    echo "Reformatting"
    inpath=$outpath
    outpath=$finaloutpath
    echo $outpath $inpath
    python ~/code/oss/gdal_calc.py --co="COMPRESS=LZW" --type Byte -A $inpath --outfile $outpath --calc="A*100" --overwrite --NoDataValue=233
done


# need to extract year 1 w/python and Numpy, see if it looks the same as gdal_calc.py

