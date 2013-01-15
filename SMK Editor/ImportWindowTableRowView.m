//
//  ImportWindowTableRowView.m
//  SMK Editor
//
//  Created by Ian Sidor on 16/01/2012.
//  Copyright (c) 2012 Banana Iguana. All rights reserved.
//

#import "ImportWindowTableRowView.h"

@interface ImportWindowTableRowView ()

@property BOOL mouseInside;

@end

@implementation ImportWindowTableRowView

@dynamic mouseInside;

static NSGradient *gradientWithTargetColor( NSColor *targetColor )
{
    NSArray *colors								= @[[targetColor colorWithAlphaComponent:0], targetColor, targetColor, [targetColor colorWithAlphaComponent:0]];

    const CGFloat locations[ 4 ]				= { 1.0, 0.35, 0.65, 0.0 };

	NSGradient *gradient						= [[NSGradient alloc] initWithColors:colors atLocations:locations colorSpace:[NSColorSpace sRGBColorSpace]];

    return( gradient );
}


-(void)setMouseInside:(BOOL)value
{
	if( _mouseInside != value )
	{
		_mouseInside = value;
		
		[self setNeedsDisplay:YES];
    }
}

-(BOOL)mouseInside
{
    return( _mouseInside );
}

-(void)drawSelectionInRect:(NSRect)dirtyRect
{
	[[NSColor whiteColor] set];

	NSRectFill( self.bounds );

	NSGradient *gradient;
	
	gradient								= gradientWithTargetColor( [NSColor colorWithSRGBRed:( 187.0 / 255.0 ) green:( 213.0 / 255.0 ) blue:0.0 alpha:1.0] );

	NSRect selectionRect					= NSInsetRect( self.bounds, 2.0, 2.0 );

	[[NSColor colorWithCalibratedWhite:0.0 alpha:1.0] setStroke];
	[[NSColor colorWithCalibratedWhite:0.92 alpha:1.0] setFill];

	NSBezierPath *selectionPath				= [NSBezierPath bezierPathWithRoundedRect:selectionRect xRadius:7.0 yRadius:7.0];

	[selectionPath setLineWidth:0.3];
	
	[selectionPath fill];
	[selectionPath stroke];
	
	[gradient drawInBezierPath:selectionPath angle:0.0];
}

-(void)drawBackgroundInRect:(NSRect)dirtyRect
{
	[[NSColor whiteColor] set];

	NSRectFill( self.bounds );

	NSGradient *gradient;
	
	if( self.mouseInside )
	{	
		gradient								= gradientWithTargetColor( [NSColor colorWithSRGBRed:( 187.0 / 255.0 ) green:( 213.0 / 255.0 ) blue:1.0 alpha:1.0] );

		NSRect selectionRect					= NSInsetRect( self.bounds, 2.0, 2.0 );

		[[NSColor colorWithCalibratedWhite:0.0 alpha:1.0] setStroke];
		[[NSColor colorWithCalibratedWhite:0.92 alpha:1.0] setFill];

		NSBezierPath *selectionPath				= [NSBezierPath bezierPathWithRoundedRect:selectionRect xRadius:7.0 yRadius:7.0];

		[selectionPath setLineWidth:0.3];
		
		[selectionPath fill];
		[selectionPath stroke];
		
		[gradient drawInBezierPath:selectionPath angle:0.0];
	}
}

-(void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
}

-(void)ensureTrackingArea
{
    if( self.trackingArea == nil )
	{
        self.trackingArea						= [[NSTrackingArea alloc] initWithRect:NSZeroRect options:( NSTrackingInVisibleRect | NSTrackingActiveAlways | NSTrackingMouseEnteredAndExited ) owner:self userInfo:nil];
    }
}

-(void)updateTrackingAreas
{
    [super updateTrackingAreas];
	
	[self ensureTrackingArea];
	
    if( ![[self trackingAreas] containsObject:self.trackingArea] )
	{
		[self addTrackingArea:self.trackingArea];
	}
}

-(void)mouseEntered:(NSEvent*)theEvent
{
    self.mouseInside							= YES;
}

-(void)mouseExited:(NSEvent*)theEvent
{
    self.mouseInside							= NO;
}

@end
