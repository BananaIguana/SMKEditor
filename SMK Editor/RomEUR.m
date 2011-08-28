//
//  RomEUR.m
//  SMK Editor
//
//  Created by Ian Sidor on 28/08/2011.
//  Copyright (c) 2011 Roar Technology. All rights reserved.
//

#import "RomEUR.h"
#import "RomRef.h"

#define kRomOffsetTitle						0xFFC0
#define kRomOffsetCartridgeTypeOffset		0xFFD6

@implementation RomEUR

@synthesize data;
@synthesize romDict;

-(id)initWithData:(NSData*)romData
{
	self = [super init];
	
	if( self )
	{
		NSArray *objects			= [NSArray arrayWithObjects:
		
			[RomRef refWithOffset:kRomOffsetTitle type:kRomRefTypeString size:16 max:21],
			[RomRef refWithOffset:kRomOffsetCartridgeTypeOffset type:kRomRefTypeUnsignedChar size:1],
			nil];
			
		NSArray *keys				= [NSArray arrayWithObjects:
		
			[NSNumber numberWithUnsignedInt:kRomOffsetTitle],
			[NSNumber numberWithUnsignedInt:kRomOffsetCartridgeTypeOffset],
			nil];

		NSDictionary *dictionary	= [NSDictionary dictionaryWithObjects:objects forKeys:keys];
		
		self.romDict				= dictionary;
		self.data					= romData;
		
		[dictionary release];
	}
	
	return( self );
}

-(void)print
{
	NSArray *keys					= [self.romDict allKeys];
	
	NSNumber *key;
	
	for( key in keys )
	{
		RomRef *ref					= [self.romDict objectForKey:key];

		NSRange range				= NSMakeRange( ref.offset, ref.size );
		
		switch( [ref type] )
		{
			case kRomRefTypeString :
				{
					char initialTest[ range.length + 1 ];
					
					[self.data getBytes:initialTest range:range];
					initialTest[ range.length ] = 0;
	
					NSLog( @"Data = %s", initialTest );
			
				}break;
		
			case kRomRefTypeUnsignedChar :
				{
					unsigned char val;
					
					[self.data getBytes:&val range:range];
					
					NSLog( @"Data = %d", (int)val );
				
				}break;
		
			default:
				{
					NSAssert( 0, @"Unhandled type in test." );
				}
		}
	}	
}

-(void)dealloc
{
	[romDict release];

	[super dealloc];
}

@end
