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
    [_logLevelPopup selectItemWithTitle: notify_level ];
    
    NSString* menubar_behavior = [self getMenubarBehavior];
    [_menubarBehaviorPopup selectItemWithTitle: menubar_behavior ];
    
    NSString* stereo_mode = [self getOsgStereoMode];
    [_stereoModePopup selectItemWithTitle: stereo_mode];

    NSString* cursor_mode = [self getP3DCursorMode];
    [_cursorModePopup selectItemWithTitle: cursor_mode];
    
    [_splitStereoHorizontalEyeMapping selectItemWithTitle:[self getOsgSplitStereoHorizontalEyeMapping]];
    [_splitStereoVerticalEyeMapping selectItemWithTitle:[self getOsgSplitStereoVerticalEyeMapping]];
    
    [self updateStereoEyeMappingPopup: _stereoModePopup];
    
    NSString* add_params = [self getAdditionalCommandLineParameters];
    [_additonalCommandLineParametersTextView setString: add_params];
    
    _additonalCommandLineParametersTextView.automaticQuoteSubstitutionEnabled = NO;
    [_additonalCommandLineParametersTextView setEnabledTextCheckingTypes: 0];
    
    NSString* add_env_vars = [self getAdditionalEnvVars];
    [_additonalEnvVarsTextView setString: add_env_vars];
    
    _additonalEnvVarsTextView.automaticQuoteSubstitutionEnabled = NO;
    [_additonalEnvVarsTextView setEnabledTextCheckingTypes: 0];
    
    [_osgFilePathControl setURL: [self getOsgFilePath]];
    [_osgConfigPathControl setURL: [self getOsgConfigFile]];
    [_p3dCursorPathControl setURL: [self getP3DCursorFile]];
    [_leftKeystoneFile setURL: [self getLeftKeystoneFile]];
    [_rightKeystoneFile setURL: [self getRightKeystoneFile]];
    
    _osgFilePathControl.delegate = self;
    _osgConfigPathControl.delegate = self;
    _p3dCursorPathControl.delegate = self;
    _leftKeystoneFile.delegate = self;
    _rightKeystoneFile.delegate = self;
    
    unsigned int num_screens = [[NSScreen screens] count];
    
    _screenNumPopup.enabled = (num_screens > 1);
    [_screenNumPopup addItemWithTitle: @"All"];
    
    for(unsigned int i = 0; i < num_screens; i++) {
        [_screenNumPopup addItemWithTitle: [NSString stringWithFormat:@"%d", i]];
    }
    [_screenNumPopup selectItemWithTitle: [self getOsgScreen]];
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
    [defaults setValue: _screenNumPopup.titleOfSelectedItem forKey: @"OSG_SCREEN"];
    
    [defaults setValue: _stereoModePopup.titleOfSelectedItem forKey: @"OSG_STEREO_MODE"];
    [defaults setValue: _cursorModePopup.titleOfSelectedItem forKey: @"P3D_SHOW_CURSOR"];
    [defaults setValue: _additonalCommandLineParametersTextView.string forKey: @"P3D_ADDITIONAL_COMMAND_LINE_PARAMETERS"];
    [defaults setValue: _additonalEnvVarsTextView.string forKey: @"P3D_ADDITIONAL_ENV_VARS"];
    [defaults setValue: _splitStereoHorizontalEyeMapping.titleOfSelectedItem forKey: @"OSG_SPLIT_STEREO_HORIZONTAL_EYE_MAPPING"];
    [defaults setValue: _splitStereoVerticalEyeMapping.titleOfSelectedItem forKey: @"OSG_SPLIT_STEREO_VERTICAL_EYE_MAPPING"];
    
    [defaults setURL: _osgFilePathControl.URL forKey: @"OSG_FILE_PATH"];
    [defaults setURL: _osgConfigPathControl.URL forKey: @"OSG_CONFIG_FILE"];
    [defaults setURL: _p3dCursorPathControl.URL forKey: @"P3D_CURSOR"];
    
    [defaults setURL: _leftKeystoneFile.URL forKey: @"P3D_LEFT_KEYSTONE_FILE"];
    [defaults setURL: _rightKeystoneFile.URL forKey: @"P3D_RIGHT_KEYSTONE_FILE"];
    

    
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

-(IBAction) handleClearLeftKeystoneFileBtn: (id)sender
{
    [_leftKeystoneFile setURL: nil];
}


-(IBAction) handleClearRightKeystoneFileBtn: (id)sender
{
    [_rightKeystoneFile setURL: nil];
}


-(IBAction) handleConfigurationFilePathControl: (id)sender
{
    [self handleClearLeftKeystoneFileBtn: sender];
    [self handleClearRightKeystoneFileBtn: sender];
}

-(IBAction) handleKeystoneFilePathControl: (id)sender
{
    [self handleClearConfigPathBtn: sender];
}


-(IBAction) updateStereoEyeMappingPopup: (id)sender
{
    if (sender != _stereoModePopup)
        return;
    NSString* stereo_mode = _stereoModePopup.titleOfSelectedItem;

    [_splitStereoHorizontalEyeMapping setEnabled: [stereo_mode isEqualToString: @"HORIZONTAL_SPLIT"]];
    [_splitStereoVerticalEyeMapping setEnabled: [stereo_mode isEqualToString: @"VERTICAL_SPLIT"]];
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
    else if((pathControl == _leftKeystoneFile) || (pathControl == _rightKeystoneFile))
    {
        NSArray *allowed_file_types = @[@"osgt", @"osgb", @"osgx"];
        [openPanel setAllowedFileTypes: allowed_file_types];
    }
}


#pragma mark -

+(NSString*) getSavedStringForKey:(NSString*) key default: (NSString*) default_value
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* value = [defaults stringForKey: key];
    return value ? value : default_value;
}

+(NSURL*) getSavedURLForKey:(NSString*) key default: (NSURL*) default_value
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSURL* value = [defaults URLForKey: key];
    return value ? value : default_value;
}


-(NSString*) getOsgNotifyLevel
{
    return [P3DPreferencesWindow getSavedStringForKey: @"OSG_NOTIFY_LEVEL" default: @"WARN"];
}

-(NSString*) getMenubarBehavior
{
    return [P3DPreferencesWindow getSavedStringForKey: @"OSG_MENUBAR_BEHAVIOR" default: @"AUTO_HIDE"];
}

-(NSString*) getOsgScreen
{
    return [P3DPreferencesWindow getSavedStringForKey: @"OSG_SCREEN" default: @"All"];
}

-(NSURL*) getOsgFilePath
{
    return [P3DPreferencesWindow getSavedURLForKey: @"OSG_FILE_PATH" default: nil];
}


-(NSURL*) getOsgConfigFile
{
    return [P3DPreferencesWindow getSavedURLForKey: @"OSG_CONFIG_FILE" default: nil];
}

-(NSURL*) getP3DCursorFile
{
    return [P3DPreferencesWindow getSavedURLForKey: @"P3D_CURSOR" default: nil];
}

-(NSURL*) getLeftKeystoneFile
{
    return [P3DPreferencesWindow getSavedURLForKey: @"P3D_LEFT_KEYSTONE_FILE" default: nil];
}

-(NSURL*) getRightKeystoneFile
{
    return [P3DPreferencesWindow getSavedURLForKey: @"P3D_RIGHT_KEYSTONE_FILE" default: nil];
}

-(NSString*) getOsgStereoMode
{
    return [P3DPreferencesWindow getSavedStringForKey: @"OSG_STEREO_MODE" default: @"OFF"];
}

-(NSString*) getP3DCursorMode
{
    return [P3DPreferencesWindow getSavedStringForKey: @"P3D_SHOW_CURSOR" default: @"YES"];
}

-(NSString*) getAdditionalCommandLineParameters
{
    return [P3DPreferencesWindow getSavedStringForKey: @"P3D_ADDITIONAL_COMMAND_LINE_PARAMETERS" default: @""];
}

-(NSString*) getAdditionalEnvVars
{
    return [P3DPreferencesWindow getSavedStringForKey: @"P3D_ADDITIONAL_ENV_VARS" default: @""];
}

-(NSString*) getOsgSplitStereoHorizontalEyeMapping
{
    return [P3DPreferencesWindow getSavedStringForKey: @"OSG_SPLIT_STEREO_HORIZONTAL_EYE_MAPPING" default: @"LEFT_EYE_LEFT_VIEWPORT"];
}

-(NSString*) getOsgSplitStereoVerticalEyeMapping
{
    return [P3DPreferencesWindow getSavedStringForKey: @"OSG_SPLIT_STEREO_VERTICAL_EYE_MAPPING" default: @"LEFT_EYE_TOP_VIEWPORT"];
}
@end
