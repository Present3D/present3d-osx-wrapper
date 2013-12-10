//
//  P3DPreferencesWindow.m
//  Present3D
//
//  Created by Stephan Huber on 25.11.13.
//  Copyright (c) 2013 OpenSceneGraph. All rights reserved.
//

#import "P3DPreferencesWindow.h"

@implementation P3DPreferencesWindow

- (void) readPrefs
{
    NSLog(@"%@", [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);

    NSString* notify_level = [self getOsgNotifyLevel];
    NSLog(@"notify-level: %@", notify_level);
    [_logLevelPopup selectItemWithTitle: notify_level ];
    
    NSString* menubar_behavior = [self getMenubarBehavior];
    NSLog(@"menubar-behavior: %@", menubar_behavior);
    [_menubarBehaviorPopup selectItemWithTitle: menubar_behavior ];
    
    NSString* stereo_mode = [self getOsgStereoMode];
    [_stereoModePopup selectItemWithTitle: stereo_mode];
    
    [_osgFilePathControl setURL: [self getOsgFilePath]];
    [_osgConfigPathControl setURL: [self getOsgConfigFile]];
    [_p3dCursorPathControl setURL: [self getP3DCursorFile]];
    
    _osgFilePathControl.delegate = self;
    _osgConfigPathControl.delegate = self;
    _p3dCursorPathControl.delegate = self;
}



-(IBAction) handleCancelAction: (id)sender
{
    [self orderOut:self];
    [NSApp stopModal];
}


-(IBAction) handleSaveAction: (id)sender
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
   
    [defaults setValue: _logLevelPopup.titleOfSelectedItem forKey: @"OSG_NOTIFY_LEVEL"];
    [defaults setValue: _menubarBehaviorPopup.titleOfSelectedItem forKey: @"OSG_MENUBAR_BEHAVIOR"];
    [defaults setValue: _stereoModePopup.titleOfSelectedItem forKey: @"OSG_STEREO_MODE"];
    
    [defaults setURL: _osgFilePathControl.URL forKey: @"OSG_FILE_PATH"];
    [defaults setURL: _osgConfigPathControl.URL forKey: @"OSG_CONFIG_FILE"];
    [defaults setURL: _p3dCursorPathControl.URL forKey: @"P3D_CURSOR"];

    
    [defaults synchronize];
    
    [self orderOut:self];
    [NSApp stopModal];
}

-(IBAction) handleClearFilePathBtn: (id)sender
{
    [_osgFilePathControl setURL: nil];
}

-(IBAction) handleClearConfigPathBtn: (id)sender
{
    [_osgConfigPathControl setURL: nil];
}

-(IBAction) handleClearCursorPathBtn:(id)sender
{
    [_p3dCursorPathControl setURL: nil];
}

#pragma mark - NSPathControlDelegate

- (void)pathControl:(NSPathControl *)pathControl willDisplayOpenPanel:(NSOpenPanel *)openPanel
{

    [openPanel setAllowsMultipleSelection:NO];
    [openPanel setCanChooseDirectories: (pathControl == _osgFilePathControl)];
    [openPanel setCanChooseFiles: (pathControl != _osgFilePathControl)];
    [openPanel setResolvesAliases:YES];
    if (pathControl == _osgConfigPathControl)
    {
        NSArray *allowed_file_types = @[@"cfg"];
        [openPanel setAllowedFileTypes: allowed_file_types];
    }
    else if(pathControl == _p3dCursorPathControl)
    {
        NSArray *allowed_file_types = @[@"gif", @"jpg", @"png", @"tif", @"tiff"];
        [openPanel setAllowedFileTypes: allowed_file_types];
    }
}


#pragma mark -

-(NSString*) getSavedStringForKey:(NSString*) key default: (NSString*) default_value
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* value = [defaults stringForKey: key];
    return value ? value : default_value;
}

-(NSURL*) getSavedURLForKey:(NSString*) key default: (NSURL*) default_value
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSURL* value = [defaults URLForKey: key];
    return value ? value : default_value;
}


-(NSString*) getOsgNotifyLevel
{
    return [self getSavedStringForKey: @"OSG_NOTIFY_LEVEL" default: @"WARN"];
}

-(NSString*) getMenubarBehavior
{
    return [self getSavedStringForKey: @"OSG_MENUBAR_BEHAVIOR" default: @"AUTO_HIDE"];
}

-(NSURL*) getOsgFilePath
{
    return [self getSavedURLForKey: @"OSG_FILE_PATH" default: nil];
}


-(NSURL*) getOsgConfigFile
{
    return [self getSavedURLForKey: @"OSG_CONFIG_FILE" default: nil];
}

-(NSURL*) getP3DCursorFile
{
    return [self getSavedURLForKey: @"P3D_CURSOR" default: nil];
}

-(NSString*) getOsgStereoMode
{
    return [self getSavedStringForKey: @"OSG_STEREO_MODE" default: @"OFF"];
}


@end
