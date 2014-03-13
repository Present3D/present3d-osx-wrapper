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

- (void)applicationWillFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    [[NSAppleEventManager sharedAppleEventManager] setEventHandler:self andSelector:@selector(handleURLEvent:withReplyEvent:) forEventClass:kInternetEventClass andEventID:kAEGetURL];

}


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    [self stopTask: self];
}

- (void)handleURLEvent:(NSAppleEventDescriptor*)event withReplyEvent:(NSAppleEventDescriptor*)replyEvent
{
    NSString* url = [[event paramDescriptorForKeyword:keyDirectObject] stringValue];

    url = [url stringByReplacingOccurrencesOfString:@"present3d" withString: @"http"];
    [self startAppWithFile: [[NSURL alloc] initWithString: url]];
}

-(IBAction) openFile: (id)sender {
    
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
	[openDlg setCanChooseFiles:YES];
	
    NSMutableArray* file_types_nsarray = [[NSMutableArray alloc] init];
    [file_types_nsarray addObject: @"p3d"];
    [file_types_nsarray addObject: @"osgt"];
    [file_types_nsarray addObject: @"osgb"];
    [file_types_nsarray addObject: @"xml"];
    [file_types_nsarray addObject: @"osgx"];

    
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

-(IBAction) convertFiles: (id)sender {
    
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
	[openDlg setCanChooseFiles:YES];
	
    NSMutableArray* file_types_nsarray = [[NSMutableArray alloc] init];
    [file_types_nsarray addObject: @"p3d"];
    [file_types_nsarray addObject: @"osgt"];
    [file_types_nsarray addObject: @"osgb"];
    [file_types_nsarray addObject: @"xml"];
    
    //[openDlg setAllowedFileTypes: file_types_nsarray];
    [openDlg setAllowsMultipleSelection: FALSE];
    
	if ([openDlg runModal] != NSOKButton)
	{
		return;
	}
    
    [_convertFilesWindow readDefaults];
    
    NSInteger result = [NSApp runModalForWindow: _convertFilesWindow];
    [NSApp endSheet: _convertFilesWindow];
    if(result == 0)
        return;
    
    [self showLogOutput: self];
    
    NSBundle* bundle = [NSBundle mainBundle];
    NSString* launchPath = [[bundle builtInPlugInsPath]  stringByAppendingString: @"/osgconv"];
    
    NSMutableArray* arguments = [[NSMutableArray alloc] init];
    if (_convertFilesWindow.optionalParameters.string.length > 0)
        [arguments addObject: _convertFilesWindow.optionalParameters.string];
    
    NSURL* file_name_url = [[openDlg URLs] objectAtIndex:0];
    NSString* file_name_path = [file_name_url path];
    NSString* target_file_name = [[file_name_path stringByDeletingPathExtension] stringByAppendingString: [_convertFilesWindow getSelectedFileExtension]];
    [arguments addObject: file_name_path];
    [arguments addObject:target_file_name];
    
    NSMutableDictionary* environment = [[NSMutableDictionary alloc] init];
    
    [self setCommonEnvironment: environment];

    
    [self startTask: launchPath  withCWD:nil withArguments:arguments withEnvironment: environment];
    
}


-(IBAction) runScript: (id)sender {
    
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
	[openDlg setCanChooseFiles:YES];
	
    NSMutableArray* file_types_nsarray = [[NSMutableArray alloc] init];
    [file_types_nsarray addObject: @"sh"];
    [file_types_nsarray addObject: @"tcsh"];
    
    [openDlg setAllowedFileTypes: file_types_nsarray];
    [openDlg setAllowsMultipleSelection: FALSE];
    
	if ([openDlg runModal] != NSOKButton)
	{
		return;
	}
    
    
    [self showLogOutput: self];
    
    NSURL* file_name_url = [[openDlg URLs] objectAtIndex:0];
    NSString* file_name_path = [file_name_url path];
    NSString* launchPath =  @"/bin/tcsh";
    NSString* parent_folder = [file_name_path  stringByDeletingLastPathComponent];

    
    NSMutableArray* arguments = [[NSMutableArray alloc] init];
    [arguments addObject: file_name_path];
    
    NSMutableDictionary* environment = [[NSMutableDictionary alloc] init];
    
    [self setCommonEnvironment: environment];
    
    [self startTask: launchPath  withCWD:parent_folder withArguments:arguments withEnvironment: environment];
    
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
    bool is_file = [file_name isFileURL];
    
    [[NSDocumentController sharedDocumentController] noteNewRecentDocumentURL:file_name];
    NSLog(@"Start app with: %@", file_name);
    
    NSString* parent_folder = is_file ? [[file_name path] stringByDeletingLastPathComponent] : nil;
    
    NSBundle* bundle = [NSBundle mainBundle];
    NSString* launchPath = [[bundle builtInPlugInsPath]  stringByAppendingString: @"/present3d"];
    
    NSMutableArray* arguments = [[NSMutableArray alloc] init];
    if (is_file)
        [arguments addObject: [file_name path]];
    else
        [arguments addObject: [file_name absoluteString]];
    
    if([_prefWindow getAdditionalCommandLineParameters])
        [arguments addObject:[_prefWindow getAdditionalCommandLineParameters]];
        
    //[arguments addObject: @"--help"];

    
    NSMutableDictionary* environment = [[NSMutableDictionary alloc] init];
        // [environment setValue: @"100 100 800 600" forKey: @"OSG_WINDOW"];
    
    [environment setValue: [_prefWindow getMenubarBehavior] forKey: @"OSG_MENUBAR_BEHAVIOR"];

    if([_prefWindow getOsgFilePath])
        [environment setValue: [[_prefWindow getOsgFilePath] path] forKey: @"OSG_FILE_PATH"];

    if([_prefWindow getOsgConfigFile])
        [environment setValue: [[_prefWindow getOsgConfigFile] path] forKey: @"OSG_CONFIG_FILE"];
    
    if([_prefWindow getP3DCursorFile])
        [environment setValue: [[_prefWindow getP3DCursorFile] path] forKey: @"P3D_CURSOR"];

    if([_prefWindow getP3DCursorMode])
        [environment setValue: [_prefWindow getP3DCursorMode] forKey: @"P3D_SHOW_CURSOR"];
    
    if([_prefWindow getOsgScreen]) {
        NSString* osg_screen = [_prefWindow getOsgScreen];
        if (![osg_screen isEqualToString:@"All"])
            [environment setValue: osg_screen forKey: @"OSG_SCREEN"];
    }
    
    NSMutableArray* keystone_array = [[NSMutableArray alloc] init];
    if([_prefWindow getLeftKeystoneFile])
        [keystone_array addObject: [[_prefWindow getLeftKeystoneFile] path]];
    if([_prefWindow getRightKeystoneFile])
        [keystone_array addObject: [[_prefWindow getRightKeystoneFile] path]];

    if(keystone_array.count > 0) {
        [environment setValue: @"ON" forKey:@"OSG_KEYSTONE"];
        [environment setValue: [keystone_array componentsJoinedByString:@":"] forKey:@"OSG_KEYSTONE_FILES"];
    }
    
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
    
    // NSLog(@"Arguments: %@", arguments);
    // NSLog(@"Environment: %@", environment);
    
    [self setCommonEnvironment: environment];

    
    [self startTask: launchPath withCWD: parent_folder withArguments: arguments withEnvironment: environment];
}


-(void) setCommonEnvironment: (NSMutableDictionary*)environment
{

    NSBundle* bundle = [NSBundle mainBundle];
    [environment setValue: [bundle builtInPlugInsPath] forKey: @"OSG_LIBRARY_PATH"];
    [environment setValue: [bundle builtInPlugInsPath] forKey: @"OSG_BINARY_PATH"];
    
    [environment setValue: [_prefWindow getOsgNotifyLevel] forKey: @"OSG_NOTIFY_LEVEL"];

}



-(void) startTask: (NSString*)file_path withCWD: (NSString*)cwd withArguments: (NSArray*)arguments withEnvironment: (NSDictionary*)environment
{
    NSLog(@"file_path: %@", file_path);
    NSLog(@"cwd: %@", cwd);
    NSLog(@"arguments: %@", arguments);
    NSLog(@"environment: %@", environment);
    
    NSRunningApplication* my_app = [NSRunningApplication currentApplication];

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
    
    if(cwd)
        _task.currentDirectoryPath = cwd;
    
    BlockWeakSelf weakSelf = self;

    _notification = [[NSNotificationCenter defaultCenter] addObserverForName:NSFileHandleDataAvailableNotification object:[_pipe fileHandleForReading] queue:nil usingBlock:^(NSNotification *notification){
        @autoreleasepool {
            NSData *output = [[_pipe fileHandleForReading] availableData];
            NSString *outStr = [[NSString alloc] initWithData:output encoding:NSUTF8StringEncoding];
            
            if(outStr.length > 0)
            {
                [self appendToLog: outStr];
            }
            BOOL continue_reading = [weakSelf continueReading];
            if ((output.length > 0) || continue_reading)
            {
                [[_pipe fileHandleForReading] waitForDataInBackgroundAndNotify];
            }
        }
    }];
    
    _task.launchPath = file_path;
    _task.arguments = arguments;
    _task.environment = environment;
    
    _task.terminationHandler = ^(NSTask *aTask){
        dispatch_sync(dispatch_get_main_queue(), ^{
            [my_app activateWithOptions: NSApplicationActivateAllWindows | NSApplicationActivateIgnoringOtherApps];
            if(aTask.terminationStatus != 0)
                [weakSelf revealLogWindow];
            weakSelf.checkPipe = FALSE;
            [weakSelf appendToLog: @"Task finished."];
        });
    };
    
    [_task launch];
}

-(void) appendToLog: (NSString*)outStr
{
    static unsigned int max_length = 1024*1024;
    
    
    @autoreleasepool {
        NSString* new_log = [self.logWindow.outputText.string stringByAppendingString:[NSString stringWithFormat:@"\n%@", outStr]];
        
        if (new_log.length > max_length) {
            new_log = [new_log substringFromIndex: new_log.length - max_length];
        }
        
        
        [self.logWindow.outputText setFont:[NSFont userFixedPitchFontOfSize:0.0]];
        self.logWindow.outputText.string = new_log;
        // Scroll to end of outputText field
        NSRange range;
        range = NSMakeRange([self.logWindow.outputText.string length], 0);
        [self.logWindow.outputText scrollRangeToVisible:range];
    }
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
