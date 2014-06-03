#!/bin/sh

ROOT=${PWD}

TIFF_ROOT=${ROOT}/tiff-build/install

# create cmake-configuration for dcmtk
mkdir -p "${ROOT}/dcmtk-build/install"
cd ${ROOT}/dcmtk-build
cmake -G Xcode \
-D CMAKE_INSTALL_PREFIX:PATH=${ROOT}/dcmtk-build/install \
-D DCMTK_WITH_TIFF:BOOL=ON \
-D DCMTK_WITH_ICONV:BOOL=OFF \
-D DCMTK_WITH_OPENSSL:BOOL=OFF \
-D TIFF_INCLUDE_DIR:PATH=${TIFF_ROOT}/include \
-D TIFF_LIBRARY:FILEPATH=${TIFF_ROOT}/lib/libtiff.a \
-D CMAKE_OSX_DEPLOYMENT_TARGET:STRING='10.8' \
-D CMAKE_OSX_SYSROOT:STRING=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.9.sdk ../dcmtk-source

#build dcmtk
/usr/bin/xcodebuild -configuration "Release" -target "ALL_BUILD"
/usr/bin/xcodebuild -configuration "Release" -target "install"
