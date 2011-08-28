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

@implementation RomEUR

@synthesize data;
@synthesize romDict;

-(id)initWithData:(NSData*)romData
{
	self = [super init];
	
	if( self )
	{
		NSArray *objects			= [NSArray arrayWithObjects:
		
			[RomRef refWithOffset:kRomOffsetTitle size:16 max:21],
			nil];
			
		NSArray *keys				= [NSArray arrayWithObjects:
		
			[NSNumber numberWithUnsignedInt:kRomOffsetTitle],
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
	RomRef *ref						= [self.romDict objectForKey:[NSNumber numberWithUnsignedInt:kRomOffsetTitle ]];
	
	NSRange range					= NSMakeRange( ref.offset, ref.size );
	
	char initialTest[ range.length + 1 ];
	
	[self.data getBytes:initialTest range:range];
	initialTest[ range.length ] = 0;
	
	NSLog( @"%s", initialTest );
}

-(void)dealloc
{
	[romDict release];

	[super dealloc];
}

@end
