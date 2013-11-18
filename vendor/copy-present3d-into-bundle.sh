#!/bin/sh

ROOT="${PWD}/../vendor/osg-build"
echo ${ROOT}
cd ${ROOT}/lib

#copying osg-plugins
mkdir -p ${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/Contents/PlugIns
cp -a osgPlugins* ${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/Contents/PlugIns/

#copying frameworks
mkdir -p ${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/Contents/Frameworks
cp -a *.framework ${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/Contents/Frameworks/

# copying present3d-app
cd ${ROOT}/bin
cp present3d ${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/Contents/PlugIns/

