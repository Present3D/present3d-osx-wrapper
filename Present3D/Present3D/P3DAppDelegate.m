//
//  P3DAppDelegate.m
//  Present3D
//
//  Created by Stephan Huber on 18.11.13.
//  Copyright (c) 2013 OpenSceneGraph. All rights reserved.
//

#import "P3DAppDelegate.h"

@implementation P3DAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

-(IBAction) openFile: (id)sender {
    
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
	[openDlg setCanChooseFiles:YES];
	
    NSMutableArray* file_types_nsarray = [[NSMutableArray alloc] init];
    [file_types_nsarray addObject: @"p3d"];
    [file_types_nsarray addObject: @"osgt"];
    [file_types_nsarray addObject: @"osgb"];
    
    [openDlg setAllowedFileTypes: file_types_nsarray];
    [openDlg setAllowsMultipleSelection: FALSE];
    
	if ([openDlg runModal] == NSOKButton)
	{
		NSArray* files = [openDlg URLs];
		if (files) {
			NSURL* filename = [files objectAtIndex: 0];
            [self startAppWithFile: filename];
        }
	}
}


-(IBAction) stopTask: (id)sender {
    if (_task)
    {
        [_task terminate];
        _task = nil;
    }
}


- (BOOL)application:(NSApplication *)theApplication openFile:(NSString *)filename
{
    [self startAppWithFile: [NSURL fileURLWithPath:filename]];
    return YES;
}



-(void) startAppWithFile: (NSURL*) file_name
{
    [[NSDocumentController sharedDocumentController] noteNewRecentDocumentURL:file_name];
    NSLog(@"Start app with: %@", file_name);
    
    if (_task){
        [self stopTask: nil];
    }
    _task = [[NSTask alloc] init];
    NSBundle* bundle = [NSBundle mainBundle];
    _task.launchPath = [[bundle builtInPlugInsPath]  stringByAppendingString: @"/present3d"];
    
    NSMutableArray* arguments = [[NSMutableArray alloc] init];
    [arguments addObject: [file_name path]];
    //[arguments addObject: @"--help"];
    _task.arguments = arguments;
    
    NSMutableDictionary* environment = [[NSMutableDictionary alloc] init];
    [environment setValue: @"100 100 800 600" forKey: @"OSG_WINDOW"];
    [environment setValue: @"DEBUG_INFO" forKey: @"OSG_NOTIFY_LEVEL"];
    [environment setValue: [bundle builtInPlugInsPath] forKey: @"OSG_LIBRARY_PATH"];
    _task.environment = environment;
    
    [_task launch];
}


@end
