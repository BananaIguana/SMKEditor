//
//  ROMBase.m
//  SMK Editor
//
//  Created by Ian Sidor on 27/08/2011.
//  Copyright (c) 2011 Roar Technology. All rights reserved.
//

#import "ROMBase.h"
#import "RomEUR.h"

#define kRomOffsetTitle						0xFFC0
#define kRomOffsetCartridgeType				0xFFD6
#define kRomOffsetRomSize					0xFFD7
#define kRomOffsetRamSize					0xFFD8

@implementation ROMBase

@synthesize data;

-(void)test
{
	NSURL *url = [NSURL fileURLWithPath:@"/Users/Ian/smk_eur.smc"];

	NSData *rom = [[NSData alloc] initWithContentsOfURL:url];
	
	self.data = rom;

	[rom release];
		
	// Fake it as european
	
	RomEUR *eurRom = [[RomEUR alloc] initWithData:self.data];
	
	[eurRom print];
}

@end
