//
//  P3DAppDelegate.h
//  Present3D
//
//  Created by Stephan Huber on 18.11.13.
//  Copyright (c) 2013 OpenSceneGraph. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface P3DAppDelegate : NSObject <NSApplicationDelegate> {

    NSTask* _task;
}

-(IBAction) openFile: (id)sender;
-(IBAction) stopTask: (id)sender;
-(void) startAppWithFile: (NSURL*) file_name;

@property (assign) IBOutlet NSWindow *window;


@end
