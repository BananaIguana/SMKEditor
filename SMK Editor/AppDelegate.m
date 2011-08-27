//
//  AppDelegate.m
//  SMK Editor
//
//  Created by Ian Sidor on 27/08/2011.
//  Copyright (c) 2011 Roar Technology. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;

- (void)dealloc
{
	[_window release];
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	// Insert code here to initialize your application
}

@end
