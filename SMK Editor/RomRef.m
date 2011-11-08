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

@synthesize range;
@synthesize type;
@synthesize max;

-(void)setup
{

}

-(id)initWithRom:(NSData*)rom range:(NSRange)dataRange type:(kRomRefType)dataType
{
	return( [self initWithRom:rom range:dataRange type:dataType max:dataRange.length] );
}

-(id)initWithRom:(NSData*)rom range:(NSRange)dataRange type:(kRomRefType)dataType max:(NSUInteger)dataMax
{
	self = [super init];
	
	if( self )
	{
		self.range			= dataRange;
		self.type			= dataType;
		self.max			= dataMax;
		
		[self setup];
	}
	
	return( self );
}

+(RomRef*)refWithRom:(NSData*)rom range:(NSRange)dataRange type:(kRomRefType)dataType
{
	RomRef *romReference = [[RomRef alloc] initWithRom:rom range:dataRange type:dataType];
	
	[romReference autorelease];
	
	return( romReference );
}

+(RomRef*)refWithRom:(NSData*)rom range:(NSRange)dataRange type:(kRomRefType)dataType max:(NSUInteger)max
{
	RomRef *romReference = [[RomRef alloc] initWithRom:rom range:dataRange type:dataType max:max];
	
	[romReference autorelease];
	
	return( romReference );
}

+(void)logReference:(RomRef*)reference rom:(RomBase*)rom
{
	RomRef *ref					= reference;

	NSRange range				= ref.range;
	
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
