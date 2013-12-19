//
//  P3DConvertFilesWindow.h
//  Present3D
//
//  Created by Stephan Huber on 19.12.13.
//  Copyright (c) 2013 OpenSceneGraph. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface P3DConvertFilesWindow : NSWindow


@property IBOutlet NSPopUpButton *filetypePopup;
@property IBOutlet NSTextView *optionalParameters;

-(void)readDefaults;


-(IBAction) handleCancelAction: (id)sender;
-(IBAction) handleSaveAction: (id)sender;

-(NSString*) getSelectedFileExtension;


@end
