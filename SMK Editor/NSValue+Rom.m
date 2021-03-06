//
//  NSValue+Rom.m
//  SMK Editor
//
//  Created by Ian Sidor on 08/11/2011.
//  Copyright (c) 2011 Banana Iguana. All rights reserved.
//

#import "NSValue+Rom.h"

@implementation NSValue (Rom)

+(NSValue*)valueWithRomRange:(RomRange)range
{
	NSValue *value = [NSValue valueWithBytes:&range objCType:@encode(RomRange)];

	return( value );
}

-(RomRange)romRangeValue
{
	RomRange range;

	[self getValue:&range];
	
	return( range );
}

@end
