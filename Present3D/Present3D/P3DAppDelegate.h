//
//  P3DAppDelegate.h
//  Present3D
//
//  Created by Stephan Huber on 18.11.13.
//  Copyright (c) 2013 OpenSceneGraph. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "P3DPreferencesWindow.h"
#import "P3DLogWindow.h"
#import "P3DConvertFilesWindow.h"

@interface P3DAppDelegate : NSObject <NSApplicationDelegate> {

    NSTask* _task;
    NSPipe* _pipe;
    id      _notification;
}

-(IBAction) openFile: (id)sender;
-(IBAction) convertFiles: (id)sender;
-(IBAction) runScript: (id)sender;
-(IBAction) stopTask: (id)sender;
-(IBAction) showLogOutput: (id)sender;
-(IBAction) showPreferences: (id)sender;
-(void) startAppWithFile: (NSURL*) file_name;
-(void) startTask: (NSString*)file_path withCWD: (NSString*)cwd withArguments: (NSArray*)arguments withEnvironment: (NSDictionary*)envvars;
-(void) taskStopped;
-(void) revealLogWindow;
-(BOOL) continueReading;

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet P3DLogWindow *logWindow;
@property (weak) IBOutlet P3DPreferencesWindow *prefWindow;
@property (weak) IBOutlet P3DConvertFilesWindow *convertFilesWindow;
@property (assign, nonatomic) BOOL checkPipe;


@end
