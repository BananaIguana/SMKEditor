//
//  ROMBase.h
//  SMK Editor
//
//  Created by Ian Sidor on 27/08/2011.
//  Copyright (c) 2011 Roar Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kRomBaseKeyTitle				@"kRomBaseKeyTitle"				// 16	bytes
#define kRomBaseKeyCartridgeType		@"kRomBaseKeyCartridgeType"		// 1	byte
/*

	private final int	romSizeOffset					= 0xFFD7;
	private final int	ramSizeOffset					= 0xFFD8;
	private final int	destinationCodeOffset			= 0xFFD9;
	private final int	maskRomVerOffset				= 0xFFDB;
	private final int	complementCheckLowOffset		= 0xFFDC;
	private final int	complementCheckHighOffset		= 0xFFDD;
	private final int	checksumLowOffset				= 0xFFDE;
	private final int	checksumHighOffset				= 0xFFDF;
	private final int	markerCode1Offset				= 0xFFB0;
	private final int	markerCode2Offset				= 0xFFB1;
	private final int	gameCode1Offset					= 0xFFB2;
	private final int	gameCode2Offset					= 0xFFB3;
	private final int	gameCode3Offset					= 0xFFB4;
	private final int	gameCode4Offset					= 0xFFB5;
	private final int	expansionRamSizeOffset			= 0xFFBD;
	private final int	specialVersionOffset			= 0xFFBE;
	private final int	cartridgeTypeSubNumOffset		= 0xFFBF;
*/

@interface ROMBase : NSObject
{
	NSData *data;
}

@property(nonatomic,retain) NSData *data;

-(void)test;

@end
