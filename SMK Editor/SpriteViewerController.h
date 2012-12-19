//
//  SpriteViewerController.h
//  SMK Editor
//
//  Created by Ian Sidor on 16/12/2012.
//  Copyright (c) 2012 Banana Iguana. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class RomBase;

@interface SpriteViewerController : NSWindowController

@property(strong) NSArray					*arraySprites;
@property(weak) IBOutlet NSImageView		*imageDisplay;
@property(weak) IBOutlet NSButton			*buttonLeft;
@property(weak) IBOutlet NSButton			*buttonRight;
@property(strong) RomBase					*romBase;

@end
