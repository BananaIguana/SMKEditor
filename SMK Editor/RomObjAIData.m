//
//  RomObjAIData.m
//  SMK Editor
//
//  Created by Ian Sidor on 10/12/2012.
//  Copyright (c) 2012 Banana Iguana. All rights reserved.
//

#import "RomObjAIData.h"

@implementation ReadBuffer

@end

@interface RomObjAIData()

-(void)extractZoneData;
-(void)extractTargetData;
-(void)buildContainerData;

@end

@implementation RomObjAIData

-(id)initWithRomData:(NSData*)romData zoneRange:(RomRange)zoneRange targetRange:(RomRange)targetRange
{
	self = [super init];
	
	if( self )
	{
		self.data				= romData;
		self.dataRange			= zoneRange;
		self.dataRangeTarget	= targetRange;
		self.aiDataType			= kRomNumAIData;	// Initialise to invalid value.
		
#if 0 // Temporary fix for theaded processing - I don't understand why setup has to be called on the main thread.
		[self setup];
#else
		[self performSelectorOnMainThread:@selector(setup) withObject:nil waitUntilDone:YES];
#endif
	}
	
	return( self );
}

-(void)setup
{
	[self extractZoneData];
	[self extractTargetData];
	[self buildContainerData];
}

-(void)extractZoneData
{
	int counter						= 0;
	BOOL bOk						= YES;
	
	NSMutableArray *arrayBuffer		= [NSMutableArray array];

	while( bOk )
	{
		const unsigned char *bytes	= [self.data bytes];
		
		NSUInteger location			= self.dataRange.range.location;

		unsigned char shape			= bytes[ location + counter + 0 ];

		if( shape == 0xFF )
		{
			bOk = false;

			continue;
		}
		
		unsigned char x				= bytes[ location + counter + 1 ];
		unsigned char y				= bytes[ location + counter + 2 ];
		unsigned char width			= bytes[ location + counter + 3 ];
		unsigned char height		= 0;
		
		counter	+= 4;
		
		if( shape == 0 )
		{
			height					= bytes[ location + counter ];
			
			counter++;
		}
		
		ReadBuffer *buf				= [[ReadBuffer alloc] init];
		
		buf->shapeID				= shape;
		buf->boundX					= x;
		buf->boundY					= y;
		buf->boundWidth				= width;
		buf->boundHeight			= height;
		
		[arrayBuffer addObject:buf];
	}
	
	self.readBuffer					= arrayBuffer;
}

-(void)extractTargetData
{
	__block int counter				= 0;
	
	const unsigned char *bytes		= [self.data bytes];
		
	NSUInteger location				= self.dataRangeTarget.range.location;
	
	[self.readBuffer enumerateObjectsUsingBlock:^( ReadBuffer *obj, NSUInteger idx, BOOL *stop ){
	
		unsigned char x				= bytes[ location + counter + 0 ];
		unsigned char y				= bytes[ location + counter + 1 ];
		unsigned char speed			= bytes[ location + counter + 2 ];
		
		counter						+= 3;
		
		obj->targetX				= x;
		obj->targetY				= y;
		obj->speed					= speed;
	}];
}

-(void)buildContainerData
{
	[self.readBuffer enumerateObjectsUsingBlock:^( ReadBuffer *obj, NSUInteger idx, BOOL *stop ){

		BOOL bOk					= YES;
		
		kAIZone type				= Rectangle;
					
		switch( obj->shapeID )
		{
			case 0 :				{	type = Rectangle;					}break;
			case 2 :				{	type = TriangleTopLeft;				}break;
			case 4 :				{	type = TriangleTopRight;			}break;
			case 6 :				{	type = TriangleBottomRight;			}break;
			case 8 :				{	type = TriangleBottomLeft;			}break;

			default :
				{
					bOk = false;
				}
		}
		
		if( bOk )
		{
			NSLog( @"[AI] : ---------------------------------------------------------" );
			NSLog( @"[AI] : Type = %d", type );
			NSLog( @"[AI] : X = %d : Y = %d", obj->boundX, obj->boundY );
			NSLog( @"[AI] : W = %d : H = %d", obj->boundWidth, obj->boundHeight );
			NSLog( @"[AI] : TX = %d : TY = %d", obj->targetX, obj->targetY );
			NSLog( @"[AI] : Speed = %d", obj->speed );
		}
	}];
}

-(NSString*)description
{
	return( RomTrackToString( self.aiDataType ) );
}

@end
