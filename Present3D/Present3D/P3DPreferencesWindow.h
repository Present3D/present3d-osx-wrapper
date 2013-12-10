//
//  P3DPreferencesWindow.h
//  Present3D
//
//  Created by Stephan Huber on 25.11.13.
//  Copyright (c) 2013 OpenSceneGraph. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface P3DPreferencesWindow : NSWindow<NSPathControlDelegate>



@property IBOutlet NSPopUpButton *logLevelPopup;
@property IBOutlet NSPopUpButton *menubarBehaviorPopup;
@property IBOutlet NSPopUpButton *stereoModePopup;
@property IBOutlet NSPathControl *osgFilePathControl;
@property IBOutlet NSPathControl *osgConfigPathControl;
@property IBOutlet NSPathControl *p3dCursorPathControl;
@property IBOutlet NSButton *clearFilePathBtn;
@property IBOutlet NSButton *clearConfigPathBtn;
@property IBOutlet NSButton *clearCursorFile;




-(void) readPrefs;
-(IBAction) handleCancelAction: (id)sender;
-(IBAction) handleSaveAction: (id)sender;

-(IBAction) handleClearFilePathBtn: (id)sender;
-(IBAction) handleClearConfigPathBtn: (id)sender;
-(IBAction) handleClearCursorPathBtn: (id)sender;


-(NSString*) getOsgNotifyLevel;
-(NSString*) getMenubarBehavior;
-(NSString*) getOsgStereoMode;
-(NSURL*) getOsgFilePath;
-(NSURL*) getOsgConfigFile;
-(NSURL*) getP3DCursorFile;

@end
