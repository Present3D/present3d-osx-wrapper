//
//  P3DConvertFilesWindow.m
//  Present3D
//
//  Created by Stephan Huber on 19.12.13.
//  Copyright (c) 2013 OpenSceneGraph. All rights reserved.
//

#import "P3DConvertFilesWindow.h"
#import "P3DPreferencesWindow.h"

@implementation P3DConvertFilesWindow

-(void)readDefaults
{
    NSString* file_type = [P3DPreferencesWindow getSavedStringForKey: @"P3D_CONVERT_FILES_TYPE" default: @"OpenSceneGraph Text (osgt)"];
    [_filetypePopup selectItemWithTitle: file_type];
    
    NSString* optional_arguments = [P3DPreferencesWindow getSavedStringForKey: @"P3D_CONVERT_FILES_ARGUMENTS" default: @""];
    _optionalParameters.string = optional_arguments;
    _optionalParameters.automaticQuoteSubstitutionEnabled = NO;
    [_optionalParameters setEnabledTextCheckingTypes: 0];
}


-(IBAction) handleCancelAction: (id)sender
{
    [self orderOut:self];
    [NSApp stopModalWithCode:0];
}


-(IBAction) handleSaveAction: (id)sender
{   
     NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
   
    [defaults setValue: _filetypePopup.titleOfSelectedItem forKey: @"P3D_CONVERT_FILES_TYPE"];
    [defaults setValue: _optionalParameters.string forKey: @"P3D_CONVERT_FILES_ARGUMENTS"];


    [self orderOut:self];
    [NSApp stopModalWithCode:1];
}

-(NSString*) getSelectedFileExtension
{
    NSMenuItem* item = [_filetypePopup itemAtIndex: _filetypePopup.indexOfSelectedItem];
    switch (item.tag) {
    
        case 2:
            return @".osgb";
            break;
        case 3:
            return @".osgx";
            break;
        default:
            return @".osgt";
            break;
    }
    
}

@end
