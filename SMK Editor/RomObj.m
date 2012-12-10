//
//  RomObj.m
//  SMK Editor
//
//  Created by Ian Sidor on 08/11/2011.
//  Copyright (c) 2011 Banana Iguana. All rights reserved.
//

#import "RomObj.h"

@implementation RomObj

-(id)initWithRomData:(NSData*)romData range:(RomRange)range
{
	self = [super init];
	
	if( self )
	{
		self.data			= romData;
		self.dataRange		= range;
		
#if 0 // Temporary fix for theaded processing - I don't understand why setup has to be called on the main thread.
		[self setup];
#else
		[self performSelectorOnMainThread:@selector(setup) withObject:nil waitUntilDone:YES];
#endif
	}
	
	return( self );
}

-(void)setup
{
	NSAssert( nil, @"Override this function." );
}

@end
