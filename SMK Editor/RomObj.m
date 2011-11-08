//
//  RomObj.m
//  SMK Editor
//
//  Created by Ian Sidor on 08/11/2011.
//  Copyright (c) 2011 Banana Iguana. All rights reserved.
//

#import "RomObj.h"

@implementation RomObj

@synthesize data;
@synthesize dataRange;

-(id)initWithRomData:(NSData*)romData range:(RomRange)range
{
	self = [super init];
	
	if( self )
	{
		self.data			= romData;
		self.dataRange		= range;
		
		[self setup];
	}	
	
	return( self );
}

-(void)setup
{
	NSAssert( nil, @"Override this function." );
}

-(void)dealloc
{
	[data release];

	[super dealloc];
}

@end
