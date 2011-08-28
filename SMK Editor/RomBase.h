//
//  ROMBase.h
//  SMK Editor
//
//  Created by Ian Sidor on 27/08/2011.
//  Copyright (c) 2011 Roar Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kRomBaseKeyTitle			@"kRomBaseKeyTitle"

@interface ROMBase : NSObject
{
	NSData *data;
}

@property(nonatomic,retain) NSData *data;

-(void)test;

@end
