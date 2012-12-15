//
//  SMKTrackView.m
//  SMK Editor
//
//  Created by Ian Sidor on 01/01/2012.
//  Copyright (c) 2012 Banana Iguana. All rights reserved.
//

#import "SMKTrackView.h"
#import "RomObjTrack.h"
#import "RomObjOverlay.h"
#import "RomObjAIData.h"
#import "TrackEditorWindow.h"

@interface SMKTrackView()

@property(atomic,readwrite,assign) TrackViewOperationMode mode;

@end

@implementation SMKTrackView

@dynamic drawOverlay;
@dynamic drawAI;

-(id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];

    if( self )
	{
		self.mode							= TrackViewOperationModeNone;
		
		scale								= 1.0f;
		scaleSource							= 1024.0f;
		trans								= NSMakePoint( 0.0f, 0.0f );
		
		self.drawOverlay					= YES;
		self.drawAI							= NO;
    }
    
    return( self );
}

-(BOOL)acceptsFirstResponder
{
	return( YES );
}

-(void)updateCursorForOperationState
{
	switch( self.mode )
	{
		case TrackViewOperationModeRequestTranslate :
		case TrackViewOperationModeRequestZoom :		{	[[NSCursor openHandCursor] set];	}break;
		case TrackViewOperationModeTranslating :
		case TrackViewOperationModeZooming :			{	[[NSCursor closedHandCursor] set];	}break;
		case TrackViewOperationModeNone :
		default :										{	[[NSCursor arrowCursor] set];		}break;
	}
}

-(void)flagsChanged:(NSEvent*)theEvent
{
	[super flagsChanged:theEvent];
	
	BOOL ctrlPressed, altPressed;
	
	( [theEvent modifierFlags] & NSControlKeyMask ) ? ( ctrlPressed = YES ) : ( ctrlPressed = NO );
	( [theEvent modifierFlags] & NSAlternateKeyMask ) ? ( altPressed = YES ) : ( altPressed = NO );
	
	if( altPressed )
	{
		self.mode = TrackViewOperationModeRequestZoom;
	}
	else if( ctrlPressed )
	{
		self.mode = TrackViewOperationModeRequestTranslate;
	}
	else
	{
		self.mode = TrackViewOperationModeNone;
	}
	
	[self updateCursorForOperationState];
}

-(void)mouseDown:(NSEvent*)theEvent
{
	[super mouseDown:theEvent];
	
	if( theEvent.type == NSLeftMouseDown )
	{
		switch( self.mode )
		{
			case TrackViewOperationModeRequestTranslate :
				{
					self.mode = TrackViewOperationModeTranslating;

				}break;
				
			case TrackViewOperationModeRequestZoom :
				{
					self.mode = TrackViewOperationModeZooming;

				}break;
				
			default :
				{
				}
		}

		[self updateCursorForOperationState];
		
		currentPoint						= [theEvent locationInWindow];
	}	
}

-(void)mouseDragged:(NSEvent*)theEvent
{
	[super mouseDragged:theEvent];

	NSPoint loc								= [theEvent locationInWindow];

	NSPoint diff							= NSMakePoint( loc.x - currentPoint.x, loc.y - currentPoint.y );
	
	if( self.mode == TrackViewOperationModeZooming )
	{
		scaleSource							+= ( diff.x );
		
		scale								= scaleSource / 1024.0f;
		
		currentPoint						= loc;
		
		[self setNeedsDisplay:YES];
	}
	else if( self.mode == TrackViewOperationModeTranslating )
	{
		trans.x								+= diff.x;
		trans.y								+= diff.y;
		
		currentPoint						= loc;
		
		[self setNeedsDisplay:YES];
	}
}

-(void)mouseUp:(NSEvent*)theEvent
{
	[super mouseUp:theEvent];
	
	if( theEvent.type == NSLeftMouseUp )
	{
		switch( self.mode )
		{
			case TrackViewOperationModeTranslating :
				{
					self.mode = TrackViewOperationModeRequestTranslate;

				}break;
				
			case TrackViewOperationModeZooming :
				{
					self.mode = TrackViewOperationModeRequestZoom;

				}break;
				
			default :
				{
				}
		}

		[self updateCursorForOperationState];
	}
}

-(void)drawRect:(NSRect)dirtyRect
{
	NSGraphicsContext *context				= [NSGraphicsContext currentContext];
	
	[context saveGraphicsState];

	NSBezierPath *path						= [NSBezierPath bezierPathWithRect:self.bounds];

	[path fill];

	NSAffineTransform *identityXform		= [NSAffineTransform transform];
	
	float fOfX								= self.frame.size.width / 2.0f;
	float fOfY								= self.frame.size.height / 2.0f;
	
	[identityXform translateXBy:fOfX yBy:fOfY];	
	[identityXform scaleBy:scale];
	[identityXform translateXBy:-fOfX yBy:-fOfY];
	
	[identityXform translateXBy:trans.x yBy:trans.y];

	[identityXform concat];

	// Draw Track

	[self.track draw:dirtyRect];

	// Draw Overlay
	
	if( self.drawOverlay )
	{
		RomObjOverlay *o						= self.track.overlay;
		NSRect r								= NSMakeRect( 0.0f, 0.0f, 1024.0f, 1024.0f );
		[o draw:r];
	}
	
	if( self.drawAI )
	{
		RomObjAIData *o							= self.track.aiData;
		NSRect r								= NSMakeRect( 0.0f, 0.0f, 1024.0f, 1024.0f );
		[o draw:r];
	}

	[context restoreGraphicsState];
}

-(void)setDrawOverlay:(BOOL)on
{
	@synchronized( self )
	{
		_drawOverlay						= on;

		[self setNeedsDisplay:YES];
	}
}

-(void)setDrawAI:(BOOL)on
{
	@synchronized( self )
	{
		_drawAI								= on;
		
		[self setNeedsDisplay:YES];
	}
}

-(BOOL)drawOverlay
{
	return( _drawOverlay );
}

-(BOOL)drawAI
{
	return( _drawAI );
}

@end
