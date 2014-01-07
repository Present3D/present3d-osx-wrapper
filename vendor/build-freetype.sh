#!/bin/sh

ROOT=${PWD}

# create cmake-configuration for dcmtk
mkdir -p "${ROOT}/freetype-build/install"
rm -rf "${ROOT}/freetype-source"
mkdir "${ROOT}/freetype-source"
cd "${ROOT}/freetype-source"
curl --location --output freetype.tar.gz http://download.savannah.gnu.org/releases/freetype/freetype-2.5.2.tar.gz
/usr/bin/tar xf freetype.tar.gz
cd freetype-2.5.2
./configure --prefix=${ROOT}/freetype-build/install --without-png
make
make install
