//
//  RomObjAIData.h
//  SMK Editor
//
//  Created by Ian Sidor on 10/12/2012.
//  Copyright (c) 2012 Banana Iguana. All rights reserved.
//

#import "RomObj.h"
#import "RomTypes.h"

typedef enum kAIZone
{
	Rectangle,
	TriangleTopLeft,
	TriangleTopRight,
	TriangleBottomRight,
	TriangleBottomLeft,

}kAIZone;

@interface ReadBuffer : NSObject
{
@public
	unsigned char		shapeID;
	unsigned char		boundX;
	unsigned char		boundY;
	unsigned char		boundWidth;
	unsigned char		boundHeight;
	unsigned char		targetX;
	unsigned char		targetY;
	unsigned char		speed;
	kAIZone				zone;
}

@end

@interface RomObjAIData : RomObj

-(id)initWithRomData:(NSData*)romData zoneRange:(RomRange)zoneRange targetRange:(RomRange)targetRange;
-(void)draw:(NSRect)rect;

@property(assign) RomRange				dataRangeTarget;
@property(strong) NSArray				*readBuffer;
@property(assign) kRomAIData			aiDataType;

@end
