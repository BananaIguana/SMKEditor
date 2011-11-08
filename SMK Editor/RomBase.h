//
//  RomBase.h
//  SMK Editor
//
//  Created by Ian Sidor on 27/08/2011.
//  Copyright (c) 2011 Roar Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum kRomHandle
{
	kRomHandleTitle,
	kRomHandleCartridgeTypeOffset,
	kRomHandleRomSizeOffset,
	kRomHandleRamSizeOffset,
	kRomHandleDestinationCodeOffset,
	kRomHandleMaskRomVerOffset,
	kRomHandleComplementCheckLowOffset,
	kRomHandleComplementCheckHighOffset,
	kRomHandleChecksumLowOffset,
	kRomHandleChecksumHighOffset,
	kRomHandleMarkerCode1Offset,
	kRomHandleMarkerCode2Offset,
	kRomHandleGameCode1Offset,
	kRomHandleGameCode2Offset,
	kRomHandleGameCode3Offset,
	kRomHandleGameCode4Offset,
	kRomHandleExpansionRamSizeOffset,
	kRomHandleSpecialVersionOffset,
	kRomHandleCartridgeTypeSubNumOffset,
	
	kRomNumHandles,

}kRomHandle;

@interface RomBase : NSObject
{
	NSData				*data;
	NSDictionary		*romDict;
}

@property(nonatomic,retain) NSData				*data;
@property(nonatomic,retain) NSDictionary		*romDict;

-(id)initWithData:(NSData*)romData offsetDictionary:(NSDictionary*)dictionary;

-(void)test;

+(NSDictionary*)offsetDictionary;

@end
