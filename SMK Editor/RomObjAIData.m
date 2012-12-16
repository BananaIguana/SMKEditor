//
//  RomObjAIData.m
//  SMK Editor
//
//  Created by Ian Sidor on 10/12/2012.
//  Copyright (c) 2012 Banana Iguana. All rights reserved.
//

#import <AppKit/AppKit.h>

#import "RomObjAIData.h"

@implementation ReadBuffer

@end

@interface RomObjAIData()

-(void)extractZoneData;
-(void)extractTargetData;
-(void)buildContainerData;

@end

#define TARGET_SCALAR				8
#define POLY_SCALAR					16

@implementation RomObjAIData

-(id)initWithRomData:(NSData*)romData zoneRange:(RomRange)zoneRange targetRange:(RomRange)targetRange
{
	self = [super init];
	
	if( self )
	{
		self.data					= romData;
		self.dataRange				= zoneRange;
		self.dataRangeTarget		= targetRange;
		self.aiDataType				= kRomNumAIData;	// Initialise to invalid value.
		
		[self setup];
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
					NSAssert( 0, @"Invalid shape ID" );
				}
		}
		
		obj->zone					= type;
	}];
}

-(NSString*)description
{
	return( RomTrackToString( self.aiDataType ) );
}

-(void)draw:(NSRect)rect
{
	NSBezierPath *path				= [NSBezierPath bezierPath];

	[self.readBuffer enumerateObjectsUsingBlock:^( id obj, NSUInteger idx, BOOL *stop ){

		ReadBuffer *buf				= (ReadBuffer*)obj;
		
		CGPoint point				= CGPointMake( buf->targetX * TARGET_SCALAR, buf->targetY * TARGET_SCALAR );

		CGRect rect					= CGRectMake(
			
			buf->boundX				* POLY_SCALAR,
			buf->boundY				* POLY_SCALAR,
			buf->boundWidth			* POLY_SCALAR,
			buf->boundHeight		* POLY_SCALAR
		);
		
		const CGFloat kCircleSize	= 4.0;
		
		CGRect pointRect			= CGRectMake( point.x - kCircleSize, point.y - kCircleSize, kCircleSize * 2.0, kCircleSize * 2.0 );
		
		[path appendBezierPathWithOvalInRect:pointRect];
		
		switch( buf->zone )
		{
			case Rectangle :
				{
					CGFloat X2		= rect.origin.x + rect.size.width;
					CGFloat Y2		= rect.origin.y + rect.size.height;
		
					[path moveToPoint:rect.origin];
					[path lineToPoint:NSMakePoint( X2, rect.origin.y )];
					[path lineToPoint:NSMakePoint( X2, rect.origin.y + rect.size.height )];
					[path lineToPoint:NSMakePoint( rect.origin.x, Y2 )];
					[path lineToPoint:rect.origin];
					[path closePath];
				
				}break;
				
			case TriangleTopLeft :
				{
					CGFloat X2		= rect.origin.x + rect.size.width;
					CGFloat Y2		= rect.origin.y + rect.size.width;
					
					X2				+= POLY_SCALAR;
					Y2				+= POLY_SCALAR;

					[path moveToPoint:rect.origin];
					[path lineToPoint:NSMakePoint( X2, rect.origin.y )];
					[path lineToPoint:NSMakePoint( rect.origin.x, Y2 )];
					[path lineToPoint:rect.origin];

				}break;
				
			case TriangleTopRight :
				{
					rect.origin.x	+= POLY_SCALAR;

					CGFloat X2		= rect.origin.x - rect.size.width;
					CGFloat Y2		= rect.origin.y + rect.size.width;
					
					X2				-= POLY_SCALAR;

					[path moveToPoint:rect.origin];
					[path lineToPoint:NSMakePoint( X2, rect.origin.y )];
					[path lineToPoint:NSMakePoint( rect.origin.x, Y2 )];
					[path lineToPoint:rect.origin];

				}break;
				
			case TriangleBottomLeft :
				{
					rect.origin.y	+= POLY_SCALAR;
				
					CGFloat X2		= rect.origin.x + rect.size.width;
					CGFloat Y2		= rect.origin.y - rect.size.width;
					
					X2				+= POLY_SCALAR;

					[path moveToPoint:rect.origin];
					[path lineToPoint:NSMakePoint( X2, rect.origin.y )];
					[path lineToPoint:NSMakePoint( rect.origin.x, Y2 )];
					[path lineToPoint:rect.origin];

				}break;
				
			case TriangleBottomRight :
				{
					rect.origin.x	+= POLY_SCALAR;
					rect.origin.y	+=POLY_SCALAR;
					
					CGFloat X2		= rect.origin.x - rect.size.width;
					CGFloat Y2		= rect.origin.y - rect.size.width;

					[path moveToPoint:rect.origin];
					[path lineToPoint:NSMakePoint( rect.origin.x, Y2 )];
					[path lineToPoint:NSMakePoint( X2, rect.origin.y )];
					[path lineToPoint:rect.origin];

				}break;
		}
	}];
	
	NSAffineTransform *transform	= [NSAffineTransform transform];
	
	[transform translateXBy:0.0 yBy:1024];
	[transform scaleXBy:1.0 yBy:-1.0];
	
	[path transformUsingAffineTransform:transform];
	
	[[NSColor whiteColor] set];
	[path stroke];
}

@end
