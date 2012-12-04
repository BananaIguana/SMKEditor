//
//  RomObjPalette.h
//  SMK Editor
//
//  Created by Ian Sidor on 12/11/2011.
//  Copyright (c) 2011 Banana Iguana. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RomObj.h"

@interface RomObjPalette : RomObj

@property(strong) NSArray			*colour;

-(NSString*)description;

@end
