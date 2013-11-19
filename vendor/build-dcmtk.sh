#!/bin/sh

ROOT=${PWD}

# create cmake-configuration for dcmtk
mkdir -p "${ROOT}/dcmtk-build/install"
cd ${ROOT}/dcmtk-build
/usr/bin/cmake -G Xcode \
-D CMAKE_INSTALL_PREFIX:PATH=${ROOT}/dcmtk-build/install \
-D DCMTK_WITH_TIFF:BOOL=OFF \
-D DCMTK_WITH_ICONV:BOOL=OFF \
-D DCMTK_WITH_OPENSSL:BOOL=OFF \
-D CMAKE_OSX_SYSROOT:STRING=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.9.sdk ../dcmtk-source

#build dcmtk
/usr/bin/xcodebuild -configuration "Release" -target "ALL_BUILD"
/usr/bin/xcodebuild -configuration "Release" -target "install"
