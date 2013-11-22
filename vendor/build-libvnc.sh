#!/bin/sh

ROOT=${PWD}

# create cmake-configuration for dcmtk
mkdir -p "${ROOT}/libvnc-build/install"
cd ${ROOT}/libvnc-build
/usr/bin/cmake -G Xcode \
-D CMAKE_INSTALL_PREFIX:PATH=${ROOT}/libvnc-build/install \
-D LIBGCRYPT_LIBRARIES:PATH='' \
-D GNUTLS_LIBRARY:PATH='' \
-D OPENSSL_CRYPTO_LIBRARY:PATH='' \
-D OPENSSL_SSL_LIBRARY:PATH='' \
-D OPENSSL_FOUND:BOOL=ON \
-D LIBVNCSERVER_WITH_WEBSOCKETS:BOOL=OFF \
-D CMAKE_OSX_DEPLOYMENT_TARGET:STRING='10.8' \
-D CMAKE_OSX_SYSROOT:STRING=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.9.sdk ../libvnc-source

#build dcmtk
/usr/bin/xcodebuild -configuration "Release" -target "ALL_BUILD"
/usr/bin/xcodebuild -configuration "Release" -target "install"
