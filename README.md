present3d-osx-wrapper
=====================

This readme is still w.i.p.

this small Objective-C based app will wrap around the command-line-application present3d which is part of the official OpenSceneGraph distribution. It adds a common user-interface to open presentations via double-click/File Open/ Drag'n'drop. 

There's even a preferences window, so you can adjust the various options for present3d. 

This repository includes some submodules + build-scripts, so that OpenSceneGraph and its dependencies are downloaded automatically and compiled. OSG and its plugins gets embedded into the wrapper-app-bundle, so there's no need for a custom installation process. Just zip the app, distribute it and unzip it. 


