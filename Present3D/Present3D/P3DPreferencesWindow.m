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
    
    
    [defaults synchronize];
    
    [self orderOut:self];
    [NSApp stopModal];
}

-(NSString*) getSavedStringForKey:(NSString*) key default: (NSString*) default_value
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* value = [defaults stringForKey: key];
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

@end
