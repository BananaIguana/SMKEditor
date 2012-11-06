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

@synthesize trackingArea;

static NSGradient *gradientWithTargetColor(NSColor *targetColor)
{
    NSArray *colors = @[[targetColor colorWithAlphaComponent:0], targetColor, targetColor, [targetColor colorWithAlphaComponent:0]];

    const CGFloat locations[4] = { 0.0, 0.35, 0.65, 1.0 };

    return [[[NSGradient alloc] initWithColors:colors atLocations:locations colorSpace:[NSColorSpace sRGBColorSpace]] autorelease];
}


-(void)setMouseInside:(BOOL)value
{
	if( mouseInside != value )
	{
		mouseInside = value;
		
		[self setNeedsDisplay:YES];
    }
}

-(BOOL)mouseInside
{
    return( mouseInside );
}

-(void)drawBackgroundInRect:(NSRect)dirtyRect
{
    [self.backgroundColor set];

    NSRectFill( self.bounds );

	NSGradient *gradient;
	
	if( self.mouseInside )
	{	
		gradient = gradientWithTargetColor( [NSColor redColor] );
	}
	else
	{
		gradient = gradientWithTargetColor( [NSColor whiteColor] );
	}
	
	[gradient drawInRect:self.bounds angle:0];
}

-(void)ensureTrackingArea
{
    if( self.trackingArea == nil )
	{
        self.trackingArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect options:NSTrackingInVisibleRect | NSTrackingActiveAlways | NSTrackingMouseEnteredAndExited owner:self userInfo:nil];
    }
}

-(void)updateTrackingAreas
{
    [super updateTrackingAreas];
	
	[self ensureTrackingArea];
	
    if( ![[self trackingAreas] containsObject:trackingArea] )
	{
		[self addTrackingArea:self.trackingArea];
	}
}

-(void)mouseEntered:(NSEvent*)theEvent
{
    self.mouseInside = YES;
}

-(void)mouseExited:(NSEvent*)theEvent
{
    self.mouseInside = NO;
}

-(void)dealloc
{
	[trackingArea release];

	[super dealloc];
}

@end
