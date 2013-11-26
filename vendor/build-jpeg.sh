#!/bin/sh

ROOT=${PWD}

# create cmake-configuration for dcmtk
mkdir -p "${ROOT}/jpeg-build/install"
rm -rf "${ROOT}/jpeg-source"
mkdir "${ROOT}/jpeg-source"
cd "${ROOT}/jpeg-source"
wget http://www.ijg.org/files/jpegsrc.v9.tar.gz
/usr/bin/tar xf jpegsrc.v9.tar.gz
cd jpeg-9
patch  < ${ROOT}/patches/lib-jpeg.patch
./configure --prefix=${ROOT}/jpeg-build/install
make
make install
