agg-hansen
==========

Aggregate 30 meter forest loss data from Hansen et al. (2013) into other resolutions.

### Dependencies
```shell
sudo add-apt-repository --yes ppa:ubuntugis/ubuntugis-unstable
sudo apt-get update
sudo apt-get install gdal-bin=1.10.1+dfsg-5ubuntu1 # required for average resampling
```

### Running
Make sure you use the `bash` command, not `sh`. We're using some `bash`-specific commands here.

```shell
bash process.sh
```

Now just sit back and enjoy a beer while the processing gnomes work their magic!
