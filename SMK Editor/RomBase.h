//
//  RomBase.h
//  SMK Editor
//
//  Created by Ian Sidor on 27/08/2011.
//  Copyright (c) 2011 Roar Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RomBase : NSObject
{
	NSData				*data;
	NSDictionary		*romDict;
}

@property(nonatomic,retain) NSData				*data;
@property(nonatomic,retain) NSDictionary		*romDict;

-(id)initWithData:(NSData*)romData offsetDictionary:(NSDictionary*)dictionary;

-(void)test;

+(NSDictionary*)offsetDictionary;

@end
