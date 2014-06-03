#!/bin/sh

ROOT=${PWD}

JPEG_ROOT=${ROOT}/jpeg-build/install
PNG_ROOT=${ROOT}/png-build/install

# create cmake-configuration for libvnc
mkdir -p "${ROOT}/libvnc-build/install"
cd ${ROOT}/libvnc-build
cmake -G Xcode \
-D CMAKE_INSTALL_PREFIX:PATH=${ROOT}/libvnc-build/install \
-D LIBGCRYPT_LIBRARIES:PATH='' \
-D GNUTLS_LIBRARY:PATH='' \
-D OPENSSL_CRYPTO_LIBRARY:PATH='' \
-D OPENSSL_SSL_LIBRARY:PATH='' \
-D OPENSSL_FOUND:BOOL=ON \
-D LIBVNCSERVER_WITH_WEBSOCKETS:BOOL=OFF \
-D CMAKE_OSX_DEPLOYMENT_TARGET:STRING='10.8' \
-D JPEG_INCLUDE_DIR:PATH=${JPEG_ROOT}/include \
-D JPEG_LIBRARY:FILEPATH=${JPEG_ROOT}/lib/libjpeg.a \
-D PNG_INCLUDE_DIR:PATH=${PNG_ROOT}/include \
-D PNG_LIBRARY:FILEPATH=${PNG_ROOT}/lib/libpng.a \
-D CMAKE_C_FLAGS_RELEASE:STRING='-O3 -DNDEBUG -DHAVE_BOOLEAN' \
-D CMAKE_OSX_SYSROOT:STRING=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.9.sdk ../libvnc-source

#build dcmtk
/usr/bin/xcodebuild -configuration "Release" -target "ALL_BUILD"
/usr/bin/xcodebuild -configuration "Release" -target "install"
