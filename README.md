present3d-osx-wrapper
=====================

This readme is still w.i.p.

this small Objective-C based app will wrap around the command-line-application present3d which is part of the official OpenSceneGraph distribution. It adds a common user-interface to open presentations via double-click/File Open/ Drag'n'drop.

There's even a preferences window, so you can adjust the various options for present3d.

This repository includes some submodules + build-scripts, so that OpenSceneGraph and its dependencies are downloaded automatically and compiled. OSG and its plugins gets embedded into the wrapper-app-bundle, so there's no need for a custom installation process. Just zip the app, distribute it and unzip it.

Prerequisites
-------------

* a recent install of xcode
* wget (install it via homebrew of macports)

Installation
------------

1. Clone this repository onto your computer
        git clone https://github.com/Present3D/present3d-osx-wrapper.git
2. init + update the submodules
        git submodule init
        git submodule update
3. compile+link the 3rdparty-software, you'll find a bunch of shell scripts in the vendor-folder. First compile jpeg, png, tiff and freetype, then dcmtk, libvnc and finally osg

   If you have problems compiling one of the dependencies, then remove the "<dependency>-build"-folder and try again.

4. open the presen3d-workspace in xcode and compile the project. There's a runscript-phase which will copy all dependeny into the app-bundle
