res=$1 # resolution in degress
path=$2
finaloutpath=$3

startyear=1
endyear=1

# extract year rasters and resample to target resolution
for yearidx in {12..12}
do
    echo $yearidx
    inpath=$path
    outpath=/tmp/tmp.tif
    gdal_calc.py --co="COMPRESS=LZW" -A $inpath --outfile $outpath --calc="A==$yearidx" --overwrite

    # echo "Warping"
    inpath=$outpath
    outpath=/tmp/tmp_avg.tif
    gdalwarp -r average -srcnodata 255 -dstnodata 255 -overwrite $inpath $outpath -tr $res $res -ot float32

    echo "Reformatting"
    inpath=$outpath
    outpath=$finaloutpath
    echo $inpath $outpath
    gdal_calc.py  -A $inpath --outfile $outpath --calc="A*100" --overwrite --NoDataValue=255 --co="COMPRESS=LZW" --type Byte
done
