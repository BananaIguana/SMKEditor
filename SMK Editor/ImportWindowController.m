//
//  ImportWindowController.m
//  SMK Editor
//
//  Created by Ian Sidor on 17/01/2012.
//  Copyright (c) 2012 Banana Iguana. All rights reserved.
//

#import "ImportWindowController.h"
#import "TrackEditorWindow.h"
#import "ImportWindow.h"

@implementation ImportWindowController

@synthesize trackWindow;

-(id)initWithTrackWindow:(TrackEditorWindow*)window
{
	self = [super initWithWindowNibName:@"ImportWindow"];
	
	if( self )
	{
		self.trackWindow				= window;
		
		ImportWindow *importWindow		= (ImportWindow*)[self window];
		
		importWindow.trackWindow		= window;
	}
	
	return( self );
}

@end
