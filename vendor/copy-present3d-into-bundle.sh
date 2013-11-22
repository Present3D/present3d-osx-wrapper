#!/bin/sh

OSG_VERSION="3.3.1"


ROOT="${PWD}/../vendor/"

cd ${ROOT}/osg-build/lib

#copying osg-plugins
mkdir -p ${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/Contents/PlugIns
cp -a osgPlugins-${OSG_VERSION} ${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/Contents/PlugIns/

#copying frameworks
mkdir -p ${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/Contents/Frameworks
cp -a *.framework ${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/Contents/Frameworks/

# copying present3d-app
cd ${ROOT}/osg-build/bin
cp present3d ${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/Contents/PlugIns/

# copy 3rdparty lubs

cd ${ROOT}/libvnc-build/install/lib
cp libvncclient.dylib ${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/Contents/Frameworks/


#fix dependencies
install_name_tool -change libvncclient.dylib @executable_path/../Frameworks/libvncclient.dylib  ${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/Contents/PlugIns/osgPlugins-${OSG_VERSION}/osgdb_vnc.so