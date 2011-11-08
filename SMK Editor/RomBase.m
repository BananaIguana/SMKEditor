//
//  RomBase.m
//  SMK Editor
//
//  Created by Ian Sidor on 27/08/2011.
//  Copyright (c) 2011 Roar Technology. All rights reserved.
//

#import "RomBase.h"
#import "RomEUR.h"
#import "RomRef.h"
#import "RomRange.h"
#import "NSValue+Rom.h"

#define kRomOffsetTitle						0xFFC0
#define kRomOffsetCartridgeType				0xFFD6
#define kRomOffsetRomSize					0xFFD7
#define kRomOffsetRamSize					0xFFD8

@implementation RomBase

@synthesize data;
@synthesize romDict;

-(id)initWithData:(NSData*)romData offsetDictionary:(NSDictionary*)dictionary
{
	self = [super init];
	
	if( self )
	{
		self.romDict				= dictionary;
		self.data					= romData;
	}
	
	return( self );
}

-(void)test
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

	NSString *romFile = [defaults stringForKey:@"rom"];
	
	NSAssert( romFile, @"Setup your rom path as a command line arg. \"-rom <path_to_rom>\"" );

	NSData *rom = [[NSData alloc] initWithContentsOfFile:romFile];
	
	NSAssert( rom, @"Failed to load ROM" );
	
	self.data = rom;

	[rom release];
		
	// Fake it as european.
	
	NSDictionary *dictionary = [RomEUR offsetDictionary];
	
	RomEUR *eurRom = [[RomEUR alloc] initWithData:self.data offsetDictionary:dictionary];
	
	NSArray *keys = [dictionary allKeys];
	
	NSNumber *key;
	
	for( key in keys )
	{
		NSValue *value = [dictionary objectForKey:key];
		
		RomRange range = [value romRangeValue];
		
		RomRef *ref = [RomRef refWithRom:self.data range:range.range type:range.type];
		
		[RomRef logReference:ref rom:(RomBase*)eurRom];
	}
}

-(void)dealloc
{
	[data release];
	[romDict release];

	[super dealloc];
}

+(NSDictionary*)offsetDictionary
{
	NSAssert( 0, @"You must override this function" );
	
	return( nil );
}

@end
