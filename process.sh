# tweakable parameters

true_res = 0.00208388888885
nominal_res = 250
basepath=/tmp/hansen

startyear=2001
endyear=2012

# setup for processing

mkdir -p $basepath/raw
mkdir -p $basepath/out
mkdir -p $basepath/mosaics

curl -O "http://commondatastorage.googleapis.com/earthenginepartners-hansen/GFC2013/lossyear.txt"

head -1 lossyear.txt > small.txt

## download all data

# while read REMOTE
# do
#    cd data/raw && { curl -O $REMOTE ; cd -; }
# done < small.txt

# process each image

for fname in $(ls $basepath/raw)
do
    echo "Processing $f ..."
    agg.sh $true_res $basepath/raw/$fname $basepath/out $startyear $endyear
done

for year in $(seq $startyear $endyear)
do
    outpath=$basepath/mosaics/hansen_loss_$year.tif
    gdal_merge.py -v -init 255 -n 255 -o /tmp/mosaic.tif $basepath/out/$year/*tif
    gdal_translate -co COMPRESS=LZW /tmp/mosaic.tif $outpath
end

s3cmd put --recursive $basepath/out/ s3://gfwdata/umd/$nominal_res

#rm lossyear.txt
rm small.txt

