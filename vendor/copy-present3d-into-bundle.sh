#!/bin/bash

# adapt to your needs

OSG_VERSION="3.3.2"


function get_realpath() {

    [[ ! -f "$1" ]] && return 1 # failure : file does not exist.
    [[ -n "$no_symlinks" ]] && local pwdp='pwd -P' || local pwdp='pwd' # do symlinks.
    echo "$( cd "$( echo "${1%/*}" )" 2>/dev/null; $pwdp )"/"${1##*/}" # echo result.
    return 0 # success

}



ROOT="${PWD}/../vendor/"

# get absolute path
ROOT=$(cd ${ROOT}; pwd)

cd ${ROOT}/osg-build/lib

# copying osg-plugins
mkdir -p "${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/Contents/PlugIns"
cp -a osgPlugins-${OSG_VERSION} "${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/Contents/PlugIns/"

# copying frameworks
rm -rf "${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/Contents/Frameworks"
mkdir -p "${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/Contents/Frameworks"
cp -a *.framework "${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/Contents/Frameworks/"

# copying present3d-app
cd ${ROOT}/osg-build/bin
cp present3d "${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/Contents/PlugIns/"

# copying osgconf
cp osgconv "${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/Contents/PlugIns/"

# copying osgversion
cp osgversion "${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/Contents/PlugIns/"

# copying osgvolume
cd ${ROOT}/osg-build/share/OpenSceneGraph/bin
cp osgvolume "${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/Contents/PlugIns/"

# copy 3rdparty libs

cd ${ROOT}/libvnc-build/install/lib
cp libvncclient.dylib "${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/Contents/Frameworks/"

cd ${ROOT}/lua-build/lib
cp liblua.dylib "${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/Contents/Frameworks/"

cd ${ROOT}/freetype-build/lib
cp libfreetype.6.dylib "${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/Contents/Frameworks/"


# fix dependencies

# libvnc
install_name_tool -change libvncclient.dylib @executable_path/../Frameworks/libvncclient.dylib  "${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/Contents/PlugIns/osgPlugins-${OSG_VERSION}/osgdb_vnc.so"

# libfreetype
install_name_tool -change "${ROOT}/freetype-build/lib/libfreetype.6.dylib" @executable_path/../Frameworks/libfreetype.6.dylib  "${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/Contents/PlugIns/osgPlugins-${OSG_VERSION}/osgdb_freetype.so"

