//
//  ImportDeleteWindowController.m
//  SMK Editor
//
//  Created by Ian Sidor on 29/01/2012.
//  Copyright (c) 2012 Banana Iguana. All rights reserved.
//

#import "ImportDeleteWindowController.h"

@implementation ImportDeleteWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

-(IBAction)buttonCancel:(NSButton*)sender
{
	NSWindow *window		= [self window];
	
	[NSApp endSheet:window returnCode:NSCancelButton];
	[window orderOut:nil];
}

-(IBAction)buttonDelete:(NSButton*)sender
{
	NSWindow *window		= [self window];
	
	[NSApp endSheet:window returnCode:NSCancelButton];
	[window orderOut:nil];
}

@end
