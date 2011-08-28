//
//  RomRef.h
//  SMK Editor
//
//  Created by Ian Sidor on 28/08/2011.
//  Copyright (c) 2011 Roar Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum kRomRefType
{
	kRomRefTypeString,
	kRomRefTypeUnsignedChar,
	
	kRomRefNumTypes,
	
}kRomRefType;

@class RomBase;

@interface RomRef : NSObject
{
	NSUInteger		offset;				// Offset from head of ROM.
	kRomRefType		type;				// Type of data
	NSUInteger		size;				// Number of bytes to read to acquire object.
	NSUInteger		max;				// Maximum size you can write at this location without causing damage. (usually the same as 'bytes')
}

@property(nonatomic,assign) NSUInteger		offset;
@property(nonatomic,assign) kRomRefType		type;
@property(nonatomic,assign) NSUInteger		size;
@property(nonatomic,assign) NSUInteger		max;

-(id)initWithOffset:(NSUInteger)dataOffset type:(kRomRefType)dataType size:(NSUInteger)dataSize max:(NSUInteger)dataMax;

+(RomRef*)refWithOffset:(NSUInteger)dataOffset type:(kRomRefType)dataType size:(NSUInteger)dataSize;
+(RomRef*)refWithOffset:(NSUInteger)dataOffset type:(kRomRefType)dataType size:(NSUInteger)dataSize max:(NSUInteger)max;

+(void)logReference:(RomRef*)reference rom:(RomBase*)rom;

@end
