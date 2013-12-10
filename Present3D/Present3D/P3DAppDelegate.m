//
//  P3DAppDelegate.m
//  Present3D
//
//  Created by Stephan Huber on 18.11.13.
//  Copyright (c) 2013 OpenSceneGraph. All rights reserved.
//

#import "P3DAppDelegate.h"

#define BlockWeakObject(o) __typeof(o) __weak
#define BlockWeakSelf BlockWeakObject(self)

@implementation P3DAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    [self stopTask: self];
}

-(IBAction) openFile: (id)sender {
    
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
	[openDlg setCanChooseFiles:YES];
	
    NSMutableArray* file_types_nsarray = [[NSMutableArray alloc] init];
    [file_types_nsarray addObject: @"p3d"];
    [file_types_nsarray addObject: @"osgt"];
    [file_types_nsarray addObject: @"osgb"];
    [file_types_nsarray addObject: @"xml"];
    
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
        
        [self taskStopped];
    }
    
}

-(void) taskStopped {
    if(_notification)
        [[NSNotificationCenter defaultCenter] removeObserver: _notification];
    _pipe = nil;
    _notification = nil;
}


- (BOOL)application:(NSApplication *)theApplication openFile:(NSString *)filename
{
    [self startAppWithFile: [NSURL fileURLWithPath:filename]];
    return YES;
}



-(void) startAppWithFile: (NSURL*) file_name
{
    NSRunningApplication* my_app = [NSRunningApplication currentApplication];
    
    [[NSDocumentController sharedDocumentController] noteNewRecentDocumentURL:file_name];
    NSLog(@"Start app with: %@", file_name);
    
    if (_task){
        [self stopTask: nil];
    }
    _task = [[NSTask alloc] init];
    _pipe = [[NSPipe alloc] init];
    [[_pipe  fileHandleForReading] waitForDataInBackgroundAndNotify];
    
    [_task setStandardError: _pipe];
    [_task setStandardOutput: _pipe];
    
    self.logWindow.outputText.string = @"";
    _checkPipe = TRUE;
    
    NSString* parent_folder = [[file_name path] stringByDeletingLastPathComponent];
    _task.currentDirectoryPath = parent_folder;
    
    BlockWeakSelf weakSelf = self;

    _notification = [[NSNotificationCenter defaultCenter] addObserverForName:NSFileHandleDataAvailableNotification object:[_pipe fileHandleForReading] queue:nil usingBlock:^(NSNotification *notification){
        
        NSData *output = [[_pipe fileHandleForReading] availableData];
        NSString *outStr = [[NSString alloc] initWithData:output encoding:NSUTF8StringEncoding];
        
        if(outStr.length > 0)
        {
            [self.logWindow.outputText setFont:[NSFont userFixedPitchFontOfSize:0.0]];
            self.logWindow.outputText.string = [self.logWindow.outputText.string stringByAppendingString:[NSString stringWithFormat:@"\n%@", outStr]];
            // Scroll to end of outputText field
            NSRange range;
            range = NSMakeRange([self.logWindow.outputText.string length], 0);
            [self.logWindow.outputText scrollRangeToVisible:range];
        }
        BOOL continue_reading = [weakSelf continueReading];
        if ((output.length > 0) || continue_reading)
        {
            [[_pipe fileHandleForReading] waitForDataInBackgroundAndNotify];
        }
    }];
    
    NSBundle* bundle = [NSBundle mainBundle];
    _task.launchPath = [[bundle builtInPlugInsPath]  stringByAppendingString: @"/present3d"];
    
    NSMutableArray* arguments = [[NSMutableArray alloc] init];
    [arguments addObject: [file_name path]];
    if([_prefWindow getAdditionalCommandLineParameters])
        [arguments addObject:[_prefWindow getAdditionalCommandLineParameters]];
        
    //[arguments addObject: @"--help"];
    _task.arguments = arguments;
    
    NSMutableDictionary* environment = [[NSMutableDictionary alloc] init];
        // [environment setValue: @"100 100 800 600" forKey: @"OSG_WINDOW"];
    
    [environment setValue: [_prefWindow getOsgNotifyLevel] forKey: @"OSG_NOTIFY_LEVEL"];
    [environment setValue: [_prefWindow getMenubarBehavior] forKey: @"OSG_MENUBAR_BEHAVIOR"];

    if([_prefWindow getOsgFilePath])
        [environment setValue: [[_prefWindow getOsgFilePath] path] forKey: @"OSG_FILE_PATH"];

    if([_prefWindow getOsgConfigFile])
        [environment setValue: [[_prefWindow getOsgConfigFile] path] forKey: @"OSG_CONFIG_FILE"];
    
    if([_prefWindow getP3DCursorFile])
        [environment setValue: [[_prefWindow getP3DCursorFile] path] forKey: @"P3D_CURSOR"];

    if([_prefWindow getP3DCursorMode])
        [environment setValue: [_prefWindow getP3DCursorMode] forKey: @"P3D_SHOW_CURSOR"];

    
    NSString* stereo_mode = [_prefWindow getOsgStereoMode];
    if (![stereo_mode isEqualToString: @"OFF"])
    {
        [environment setValue: stereo_mode forKey: @"OSG_STEREO_MODE"];
        [environment setValue: @"ON" forKey: @"OSG_STEREO"];
        if([stereo_mode isEqualToString: @"HORIZONTAL_SPLIT"])
            [environment setValue: [_prefWindow getOsgSplitStereoHorizontalEyeMapping] forKey: @"OSG_SPLIT_STEREO_HORIZONTAL_EYE_MAPPING"];

        if([stereo_mode isEqualToString: @"VERTICAL_SPLIT"])
            [environment setValue: [_prefWindow getOsgSplitStereoVerticalEyeMapping] forKey: @"OSG_SPLIT_STEREO_VERTICAL_EYE_MAPPING"];
    }
    else
    {
        [environment setValue: @"OFF" forKey: @"OSG_STEREO"];
    }
    
    [environment setValue: [bundle builtInPlugInsPath] forKey: @"OSG_LIBRARY_PATH"];
    _task.environment = environment;
    
    
    _task.terminationHandler = ^(NSTask *aTask){
        dispatch_sync(dispatch_get_main_queue(), ^{
            [my_app activateWithOptions: NSApplicationActivateAllWindows | NSApplicationActivateIgnoringOtherApps];
            if(aTask.terminationStatus != 0)
                [weakSelf revealLogWindow];
                weakSelf.checkPipe = FALSE;
        });
    };
    
    [_task launch];
}

-(BOOL)continueReading {
    // NSLog(@"Checkpipe: %i", _checkPipe);
    return _checkPipe;
}

-(void) revealLogWindow {
    [self showLogOutput: NULL];
}


-(IBAction) showLogOutput: (id)sender
{
    [_logWindow makeKeyAndOrderFront:self];
    [_logWindow setOrderedIndex:0];
}

-(IBAction) showPreferences: (id)sender
{
    [_prefWindow readPrefs];
    [NSApp runModalForWindow: _prefWindow];
    [NSApp endSheet: _prefWindow];
}
@end
