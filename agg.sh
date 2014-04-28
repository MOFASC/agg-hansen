res=$1 # resolution in degress
path=$2
basepath=$3

let startyear="$4-2000"
let endyear="$5-2000"

yeartmp=/tmp/tmp.tif
avgtmp=/tmp/tmp_avg.tif

# extract year rasters and resample to target resolution
for yearidx in $(seq $startyear $endyear)
do
    # setup
    printf -v year "20%02d" $yearidx
    outdir=$basepath/$year
    mkdir -p $outdir
    fname=$(basename $path)

    # extract data for a single year
    echo "Extracting year $yearidx"
    inpath=$path
    outpath=$yeartmp
    gdal_calc.py --co="COMPRESS=LZW" -A $inpath --outfile $outpath --calc="A==$yearidx" --overwrite

    # do averaging - float32 type
    # echo "Warping"
    inpath=$outpath
    outpath=$avgtmp
    gdalwarp -r average -srcnodata 255 -dstnodata 255 -overwrite $inpath $outpath -tr $res $res -ot float32

    # reformat data as byte type
    echo "Reformatting"
    inpath=$outpath
    outpath=$outdir/$fname
    echo $inpath $outpath
    gdal_calc.py  -A $inpath --outfile $outpath --calc="A*100" --overwrite --NoDataValue=255 --co="COMPRESS=LZW" --type Byte
done
