#!/bin/sh

ROOT=${PWD}

# create cmake-configuration for dcmtk
mkdir -p "${ROOT}/tiff-build/install"
rm -rf "${ROOT}/tiff-source"
mkdir "${ROOT}/tiff-source"
cd "${ROOT}/tiff-source"
wget http://download.osgeo.org/libtiff/tiff-4.0.3.tar.gz
tar xf tiff-4.0.3.tar.gz
cd tiff-4.0.3
./configure --disable-lzma --prefix=${ROOT}/tiff-build/install
make
make install
