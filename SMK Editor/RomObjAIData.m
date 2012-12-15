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
	[self.readBuffer enumerateObjectsUsingBlock:^( id obj, NSUInteger idx, BOOL *stop ){

		ReadBuffer *buf				= (ReadBuffer*)obj;
		
		CGPoint point				= CGPointMake( buf->targetX * TARGET_SCALAR, buf->targetY * TARGET_SCALAR );

		CGRect rect					= CGRectMake(
			
			buf->boundX				* POLY_SCALAR,
			buf->boundY				* POLY_SCALAR,
			buf->boundWidth			* POLY_SCALAR,
			buf->boundHeight		* POLY_SCALAR
		);
		
		switch( buf->zone )
		{
			case Rectangle :
				{
					NSBezierPath *path = [NSBezierPath bezierPath];

					[path moveToPoint:rect.origin];
					[path lineToPoint:NSMakePoint( rect.origin.x + rect.size.width, rect.origin.y )];
					[path lineToPoint:NSMakePoint( rect.origin.x + rect.size.width, rect.origin.y + rect.size.height )];
					[path lineToPoint:NSMakePoint( rect.origin.x, rect.origin.y + rect.size.height )];
					[path lineToPoint:rect.origin];
					[path closePath];
					[[NSColor redColor] set];
					[path stroke];
				
				}break;
				
			case TriangleTopLeft :
				{
				}break;
				
			case TriangleTopRight :
				{
				
				}break;
				
			case TriangleBottomLeft :
				{
				
				}break;
				
			case TriangleBottomRight :
				{
				
				}break;
		}
	}];
}

/*
package RomUtils.Containers;

import java.awt.Point;

import org.eclipse.swt.SWT;
import org.eclipse.swt.graphics.GC;
import org.eclipse.swt.graphics.Rectangle;
import org.eclipse.swt.graphics.Transform;

import Global.Global;
import ROM.eZone;

public class ContainerAIZoneEx extends ContainerAIZone
{
	private int[]		m_nPolygonPoints			= null;
	private Point		m_targetVisualPoint			= null;
	private final int	kPolyScalar					= 16;
	private final int	kTargetScalar				= 8;
	
	public ContainerAIZoneEx( final eZone zone, final Rectangle rect, final Point target, float speed )
	{
		super( zone, rect, target, speed );
		
		doit();
	}
	
	public void doit()
	{
		m_targetVisualPoint		= new Point( m_target.x * kTargetScalar, m_target.y * kTargetScalar );
		Rectangle rect			= new Rectangle(
				
				m_rect.x		*	kPolyScalar,
				m_rect.y		*	kPolyScalar,
				m_rect.width	*	kPolyScalar,
				m_rect.height	*	kPolyScalar
		);

		switch( m_eZone )
		{
			case Rectangle :
				{
					int nX2 = rect.x + rect.width;
					int nY2 = rect.y + rect.height;

					m_nPolygonPoints = new int[ 4 * 2 ];
					
					m_nPolygonPoints[ 0 ] = rect.x;
					m_nPolygonPoints[ 1 ] = rect.y;
					
					m_nPolygonPoints[ 2 ] = nX2;
					m_nPolygonPoints[ 3 ] = rect.y;
					
					m_nPolygonPoints[ 4 ] = nX2;
					m_nPolygonPoints[ 5 ] = nY2;
					
					m_nPolygonPoints[ 6 ] = rect.x;
					m_nPolygonPoints[ 7 ] = nY2;
		
				}break;
				
			case TriangleBottomRight :
				{
					rect.x += kPolyScalar;
					rect.y += kPolyScalar;

					int nX2 = rect.x - rect.width;
					int nY2 = rect.y - rect.width;
					
					m_nPolygonPoints = new int[ 3 * 2 ];
					
					m_nPolygonPoints[ 0 ] = rect.x;
					m_nPolygonPoints[ 1 ] = rect.y;
					
					m_nPolygonPoints[ 2 ] = rect.x;
					m_nPolygonPoints[ 3 ] = nY2;
					
					m_nPolygonPoints[ 4 ] = nX2;
					m_nPolygonPoints[ 5 ] = rect.y;
	
				}break;
				
			case TriangleTopLeft :
				{
					int nX2 = rect.x + rect.width;
					int nY2 = rect.y + rect.width;
					
					nX2 += kPolyScalar;
					nY2 += kPolyScalar;
					
					m_nPolygonPoints = new int[ 3 * 2 ];
					
					m_nPolygonPoints[ 0 ] = rect.x;
					m_nPolygonPoints[ 1 ] = rect.y;
					
					m_nPolygonPoints[ 2 ] = nX2;
					m_nPolygonPoints[ 3 ] = rect.y;
					
					m_nPolygonPoints[ 4 ] = rect.x;
					m_nPolygonPoints[ 5 ] = nY2;
				
				}break;
				
			case TriangleBottomLeft :
				{
					rect.y += kPolyScalar;
					
					int nX2 = rect.x + rect.width;
					int nY2 = rect.y - rect.width;
					
					nX2 += kPolyScalar;
					
					m_nPolygonPoints = new int[ 3 * 2 ];
					
					m_nPolygonPoints[ 0 ] = rect.x;
					m_nPolygonPoints[ 1 ] = rect.y;
					
					m_nPolygonPoints[ 2 ] = nX2;
					m_nPolygonPoints[ 3 ] = rect.y;
					
					m_nPolygonPoints[ 4 ] = rect.x;
					m_nPolygonPoints[ 5 ] = nY2;
					
				}break;
				
			case TriangleTopRight :
				{
					rect.x += kPolyScalar;
					
					int nX2 = rect.x - rect.width;
					int nY2 = rect.y + rect.width;
					
					nX2 -= kPolyScalar;
					
					m_nPolygonPoints = new int[ 3 * 2 ];
					
					m_nPolygonPoints[ 0 ] = rect.x;
					m_nPolygonPoints[ 1 ] = rect.y;
					
					m_nPolygonPoints[ 2 ] = nX2;
					m_nPolygonPoints[ 3 ] = rect.y;
					
					m_nPolygonPoints[ 4 ] = rect.x;
					m_nPolygonPoints[ 5 ] = nY2;
					
				}break;
		}
		
	}
	
	public void drawDebug( GC gc, int x, int y )
	{
		Transform t = new Transform( Global.display );
		
		t.identity();
		t.translate( (float)x, (float)y );
		
		gc.setTransform( t );
		
		if( m_nPolygonPoints != null )
		{
			gc.setForeground( Global.display.getSystemColor( SWT.COLOR_YELLOW ) );
			gc.setBackground( Global.display.getSystemColor( SWT.COLOR_YELLOW ) );
	
			gc.drawPolygon( m_nPolygonPoints );
		}
		
		gc.drawOval( m_targetVisualPoint.x, m_targetVisualPoint.y, 5, 5 );
	}
}

*/

@end
