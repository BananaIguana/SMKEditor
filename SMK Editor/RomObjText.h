//
//  RomObjText.h
//  SMK Editor
//
//  Created by Ian Sidor on 08/11/2011.
//  Copyright (c) 2011 Banana Iguana. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RomObj.h"

@interface RomObjText : RomObj
{
	NSString *text;
}

@property(nonatomic,retain) NSString *text;

-(void)setup;

-(NSString*)description;

@end
