#!/bin/sh

ROOT=${PWD}

# create cmake-configuration for dcmtk
mkdir -p "${ROOT}/png-build/install"
rm -rf "${ROOT}/png-source"
mkdir "${ROOT}/png-source"
cd "${ROOT}/png-source"
wget http://download.sourceforge.net/libpng/libpng-1.6.6.tar.gz
/usr/bin/tar xf libpng-1.6.6.tar.gz
cd libpng-1.6.6
./configure --prefix=${ROOT}/png-build/install
make
make install
