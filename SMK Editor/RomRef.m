//
//  RomRef.m
//  SMK Editor
//
//  Created by Ian Sidor on 28/08/2011.
//  Copyright (c) 2011 Roar Technology. All rights reserved.
//

#import "RomRef.h"
#import "RomBase.h"

@implementation RomRef

@synthesize offset;
@synthesize type;
@synthesize size;
@synthesize max;

-(id)initWithOffset:(NSUInteger)dataOffset type:(kRomRefType)dataType size:(NSUInteger)dataSize max:(NSUInteger)dataMax
{
	self = [super init];
	
	if( self )
	{
		self.offset			= dataOffset;
		self.type			= dataType;
		self.size			= dataSize;
		self.max			= dataMax;	
	}
	
	return( self );
}

+(RomRef*)refWithOffset:(NSUInteger)dataOffset type:(kRomRefType)dataType size:(NSUInteger)dataSize
{
	RomRef *romReference = [[RomRef alloc] initWithOffset:dataOffset type:dataType size:dataSize max:dataSize];
	
	[romReference autorelease];
	
	return( romReference );
}

+(RomRef*)refWithOffset:(NSUInteger)dataOffset type:(kRomRefType)dataType size:(NSUInteger)dataSize max:(NSUInteger)max
{
	RomRef *romReference = [[RomRef alloc] initWithOffset:dataOffset type:dataType size:dataSize max:max];
	
	[romReference autorelease];
	
	return( romReference );
}

+(void)logReference:(RomRef*)reference rom:(RomBase*)rom
{
	RomRef *ref					= reference;

	NSRange range				= NSMakeRange( ref.offset, ref.size );
	
	switch( [ref type] )
	{
		case kRomRefTypeString :
			{
				char initialTest[ range.length + 1 ];
				
				[rom.data getBytes:initialTest range:range];
				initialTest[ range.length ] = 0;

				NSLog( @"Data = %s", initialTest );
		
			}break;
	
		case kRomRefTypeUnsignedChar :
			{
				unsigned char val;
				
				[rom.data getBytes:&val range:range];
				
				NSLog( @"Data = %d", (int)val );
			
			}break;
	
		default:
			{
				NSAssert( 0, @"Unhandled type in test." );
			}
	}
}


@end
