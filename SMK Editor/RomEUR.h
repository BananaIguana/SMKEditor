//
//  RomEUR.h
//  SMK Editor
//
//  Created by Ian Sidor on 28/08/2011.
//  Copyright (c) 2011 Roar Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RomEUR : NSObject
{
	NSData				*data;
	NSDictionary		*romDict;
}

@property(nonatomic,retain) NSData				*data;
@property(nonatomic,retain) NSDictionary		*romDict;

-(id)initWithData:(NSData*)romData;

-(void)print;

@end
