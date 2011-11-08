//
//  RomBase.h
//  SMK Editor
//
//  Created by Ian Sidor on 27/08/2011.
//  Copyright (c) 2011 Banana Iguana. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RomRange.h"

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

-(id)initWithData:(NSData*)romData;

-(NSDictionary*)offsetDictionary;

// Accessors

-(RomRange)romRangeFromKey:(NSNumber*)key;
-(RomRange)romRangeFromHandle:(kRomHandle)handle;
-(NSNumber*)keyFromHandle:(kRomHandle)handle;
-(id)objectFromHandle:(kRomHandle)handle;
-(id)objectFromRange:(RomRange)range;

@end
