//
//  RomObj.h
//  SMK Editor
//
//  Created by Ian Sidor on 08/11/2011.
//  Copyright (c) 2011 Banana Iguana. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RomRange.h"

@interface RomObj : NSObject
{
	NSData			*data;
	RomRange		dataRange;
}

@property(nonatomic,retain) NSData		*data;
@property(nonatomic,assign) RomRange	dataRange;

-(id)initWithRomData:(NSData*)romData range:(RomRange)range;
-(void)setup;

@end
