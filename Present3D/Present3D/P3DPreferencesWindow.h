//
//  P3DPreferencesWindow.h
//  Present3D
//
//  Created by Stephan Huber on 25.11.13.
//  Copyright (c) 2013 OpenSceneGraph. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface P3DPreferencesWindow : NSWindow



@property IBOutlet NSPopUpButton *logLevelPopup;
@property IBOutlet NSPopUpButton *menubarBehaviorPopup;


-(void) readPrefs;
-(IBAction) handleCancelAction: (id)sender;
-(IBAction) handleSaveAction: (id)sender;

-(NSString*) getOsgNotifyLevel;
-(NSString*) getMenubarBehavior;


@end
