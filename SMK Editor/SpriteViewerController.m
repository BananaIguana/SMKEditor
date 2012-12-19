//
//  SpriteViewerController.m
//  SMK Editor
//
//  Created by Ian Sidor on 16/12/2012.
//  Copyright (c) 2012 Banana Iguana. All rights reserved.
//

#import "RomBase.h"
#import "RomObjKart.h"
#import "SpriteViewerController.h"

@interface SpriteViewerController ()

@property(assign) NSInteger drawIndex;

@end

@implementation SpriteViewerController

-(id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];

	if( self )
	{
        self.drawIndex					= 0;
		self.arraySprites				= nil;
    }
    
    return( self );
}

-(void)windowDidLoad
{
    [super windowDidLoad];
	
	// Add any more 'drawable' sprites here. Consider revising the class hierarchy to support a common sprite
	// drawing function once newer additions aside from Karts are implemeneted.
	
	NSMutableArray *images				= [NSMutableArray array];
	
	[self.romBase.karts enumerateObjectsUsingBlock:^( RomObjKart *obj, NSUInteger idx, BOOL *stop ){
	
		NSAssert( [obj isKindOfClass:[RomObjKart class]], @"This only supports 'RomObjKarts' at present" );

		NSArray *imageArray				= obj.imageArray;
		
		[images addObjectsFromArray:imageArray];
	}];
	
	self.arraySprites					= images;

	[self updateImage];
}

-(void)updateImage
{
	if( self.drawIndex < [self.arraySprites count] )
	{
		self.imageDisplay.image			= [self.arraySprites objectAtIndex:self.drawIndex];
	}
}

-(IBAction)didSelectLeftButton:(NSButton*)sender
{
	self.drawIndex--;
	
	NSUInteger count					= [self.arraySprites count];
	
	if( ( self.drawIndex < 0 ) && ( count > 1 ) )
	{
		self.drawIndex					= count - 1;
	}
	
	[self updateImage];	
}

-(IBAction)didSelectRightButton:(NSButton*)sender
{
	self.drawIndex++;
	
	NSUInteger count					= [self.arraySprites count];

	if( count > 1 )
	{
		NSUInteger index				= ( count - 1 );

		if( self.drawIndex > index )
		{
			self.drawIndex				= 0;
		}
	}
	
	[self updateImage];
}

@end
