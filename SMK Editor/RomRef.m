//
//  RomRef.m
//  SMK Editor
//
//  Created by Ian Sidor on 28/08/2011.
//  Copyright (c) 2011 Roar Technology. All rights reserved.
//

#import "RomRef.h"

@implementation RomRef

@synthesize offset;
@synthesize size;
@synthesize max;

-(id)initWithOffset:(NSUInteger)dataOffset size:(NSUInteger)dataSize max:(NSUInteger)dataMax
{
	self = [super init];
	
	if( self )
	{
		self.offset			= dataOffset;
		self.size			= dataSize;
		self.max			= dataMax;	
	}
	
	return( self );
}

+(RomRef*)refWithOffset:(NSUInteger)dataOffset size:(NSUInteger)dataSize
{
	RomRef *romReference = [[RomRef alloc] initWithOffset:dataOffset size:dataSize max:dataSize];
	
	[romReference autorelease];
	
	return( romReference );
}

+(RomRef*)refWithOffset:(NSUInteger)dataOffset size:(NSUInteger)dataSize max:(NSUInteger)max
{
	RomRef *romReference = [[RomRef alloc] initWithOffset:dataOffset size:dataSize max:max];
	
	[romReference autorelease];
	
	return( romReference );
}

@end
