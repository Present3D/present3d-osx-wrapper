#!/bin/sh

ROOT=${PWD}
DCMTK_ROOT=${ROOT}/dcmtk-build/install
LIBVNC_ROOT=${ROOT}/libvnc-build/install
BOOST_ROOT=${ROOT}/boost-source
ASIO_ROOT=${ROOT}/asio-source/asio/include
LUA_ROOT=${ROOT}/lua-build/
FREETYPE_ROOT=${ROOT}/freetype-build/

# create cmake-configuration for osg
mkdir -p "${ROOT}/osg-build"
cd ${ROOT}/osg-build
/usr/bin/cmake -G Xcode \
-D OSG_COMPILE_FRAMEWORKS:BOOL=1 \
-D OSG_COMPILE_FRAMEWORKS_INSTALL_NAME_DIR:STRING=@executable_path/../Frameworks \
-D OSG_WINDOWING_SYSTEM:STRING=Cocoa \
-D OSG_BUILD_PLATFORM_IPHONE:BOOL=0 \
-D BUILD_OSG_EXAMPLES:BOOL=ON \
-D CMAKE_OSX_ARCHITECTURES:STRING=x86_64 \
-D CMAKE_INSTALL_PREFIX="$ROOT/osg-build" \
-D OSG_PLUGINS=osgPlugins \
-D OSG_CXX_LANGUAGE_STANDARD:STRING=C++11 \
-D OSG_PLUGIN_SEARCH_INSTALL_DIR_FOR_PLUGINS:BOOL=OFF \
-D CMAKE_OSX_DEPLOYMENT_TARGET:STRING='10.8' \
-D ASIO_INCLUDE_DIR:PATH=${ASIO_ROOT} \
-D Boost_INCLUDE_DIR:PATH=${BOOST_ROOT} \
-D DCMTK_DIR:PATH=${DCMTK_ROOT} \
-D DCMTK_ROOT_INCLUDE_DIR:PATH=${DCMTK_ROOT}/include \
-D DCMTK_config_INCLUDE_DIR:PATH=${DCMTK_ROOT}/include/dcmtk/config \
-D DCMTK_dcmdata_INCLUDE_DIR:PATH=${DCMTK_ROOT}/include/dcmtk/dcmdata \
-D DCMTK_dcmdata_LIBRARY:FILEPATH=${DCMTK_ROOT}/lib/libdcmdata.a \
-D DCMTK_dcmimage_INCLUDE_DIR:PATH=${DCMTK_ROOT}/include/dcmtk/dcmimage \
-D DCMTK_dcmimage_LIBRARY:FILEPATH=${DCMTK_ROOT}/lib/libdcmimage.a \
-D DCMTK_dcmimgle_INCLUDE_DIR:PATH=${DCMTK_ROOT}/include/dcmtk/dcmimgle \
-D DCMTK_dcmimgle_LIBRARY:FILEPATH=${DCMTK_ROOT}/lib/libdcmimgle.a \
-D DCMTK_dcmnet_LIBRARY:FILEPATH=${DCMTK_ROOT}/lib/libdcmnet.a \
-D DCMTK_oflog_LIBRARY:FILEPATH=${DCMTK_ROOT}/lib/liboflog.a \
-D DCMTK_ofstd_INCLUDE_DIR:PATH=${DCMTK_ROOT}/include/dcmtk/ofstd \
-D DCMTK_ofstd_LIBRARY:FILEPATH=${DCMTK_ROOT}/lib/libofstd.a \
-D LIBVNCCLIENT_LIBRARY:FILEPATH=${LIBVNC_ROOT}/lib/libvncclient.dylib \
-D LIBVNCSERVER_LIBRARY:FILEPATH=${LIBVNC_ROOT}/lib/libvncserver.dylib \
-D LIBVNCSERVER_INCLUDE_DIR:FILEPATH=${LIBVNC_ROOT}/include \
-D LUA_LIBRARY:FILEPATH=${LUA_ROOT}/lib/liblua.dylib \
-D LUA_INCLUDE_DIR:PATH=${LUA_ROOT}/include \
-D FREETYPE_LIBRARY:FILEPATH=${FREETYPE_ROOT}/lib/libfreetype.6.dylib \
-D FREETYPE_INCLUDE_DIR_freetype2:PATH=${FREETYPE_ROOT}/include/freetype2 \
-D FREETYPE_INCLUDE_DIR_ft2build:PATH=${FREETYPE_ROOT}/include/freetype2 \
-D CMAKE_OSX_SYSROOT:STRING=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.9.sdk ../osg-source

#build osg
/usr/bin/xcodebuild -configuration "Release" -target "ALL_BUILD"
/usr/bin/xcodebuild -configuration "Release" -target "install"
