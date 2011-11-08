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
	NSRange			range;				// Offset from head of ROM & length of referenced data.
	kRomRefType		type;				// Type of data
	NSUInteger		max;				// Maximum size you can write at this location without causing damage. (usually the same as the range)
}

@property(nonatomic,assign) NSRange			range;
@property(nonatomic,assign) kRomRefType		type;
@property(nonatomic,assign) NSUInteger		max;

-(void)setup;

-(id)initWithRom:(NSData*)rom range:(NSRange)dataRange type:(kRomRefType)dataType;
-(id)initWithRom:(NSData*)rom range:(NSRange)dataRange type:(kRomRefType)dataType max:(NSUInteger)dataMax;

+(RomRef*)refWithRom:(NSData*)rom range:(NSRange)dataRange type:(kRomRefType)dataType;
+(RomRef*)refWithRom:(NSData*)rom range:(NSRange)dataRange type:(kRomRefType)dataType max:(NSUInteger)max;

+(void)logReference:(RomRef*)reference rom:(RomBase*)rom;

@end
