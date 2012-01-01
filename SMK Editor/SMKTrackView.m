//
//  SMKTrackView.m
//  SMK Editor
//
//  Created by Ian Sidor on 01/01/2012.
//  Copyright (c) 2012 Banana Iguana. All rights reserved.
//

#import "SMKTrackView.h"
#import "RomObjTrack.h"

@implementation SMKTrackView

@synthesize track;

-(id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];

    if( self )
	{

    }
    
    return( self );
}

-(void)drawRect:(NSRect)dirtyRect
{
	NSLog( @"Rect = %@", NSStringFromRect( dirtyRect ) );
	
	[track draw];	
}

-(void)dealloc
{
	[track release];

	[super dealloc];
}

@end
