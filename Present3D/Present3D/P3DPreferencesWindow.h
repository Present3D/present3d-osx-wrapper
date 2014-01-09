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
@property IBOutlet NSPopUpButton *cursorModePopup;
@property IBOutlet NSPopUpButton *splitStereoHorizontalEyeMapping;
@property IBOutlet NSPopUpButton *splitStereoVerticalEyeMapping;
@property IBOutlet NSTextView *additonalCommandLineParametersTextView;

@property IBOutlet NSPathControl *osgFilePathControl;
@property IBOutlet NSPathControl *osgConfigPathControl;
@property IBOutlet NSPathControl *p3dCursorPathControl;
@property IBOutlet NSPathControl *leftKeystoneFile;
@property IBOutlet NSPathControl *rightKeystoneFile;
@property IBOutlet NSButton *clearFilePathBtn;
@property IBOutlet NSButton *clearConfigPathBtn;
@property IBOutlet NSButton *clearCursorFile;




-(void) readPrefs;
-(IBAction) handleCancelAction: (id)sender;
-(IBAction) handleSaveAction: (id)sender;

-(IBAction) handleConfigurationFilePathControl: (id)sender;
-(IBAction) handleKeystoneFilePathControl: (id)sender;


-(IBAction) handleClearFilePathBtn: (id)sender;
-(IBAction) handleClearConfigPathBtn: (id)sender;
-(IBAction) handleClearCursorPathBtn: (id)sender;
-(IBAction) handleClearLeftKeystoneFileBtn: (id)sender;
-(IBAction) handleClearRightKeystoneFileBtn: (id)sender;

-(IBAction) updateStereoEyeMappingPopup: (id)sender;

+(NSString*) getSavedStringForKey:(NSString*) key default: (NSString*) default_value;
+(NSURL*) getSavedURLForKey:(NSString*) key default: (NSURL*) default_value;


-(NSString*) getOsgNotifyLevel;
-(NSString*) getMenubarBehavior;
-(NSString*) getOsgStereoMode;
-(NSURL*) getOsgFilePath;
-(NSURL*) getOsgConfigFile;
-(NSURL*) getP3DCursorFile;
-(NSString*)getP3DCursorMode;
-(NSString*)getAdditionalCommandLineParameters;
-(NSString*) getOsgSplitStereoHorizontalEyeMapping;
-(NSString*) getOsgSplitStereoVerticalEyeMapping;
-(NSURL*) getLeftKeystoneFile;
-(NSURL*) getRightKeystoneFile;

@end
