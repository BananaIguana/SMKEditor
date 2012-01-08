//
//  RomObj.h
//  SMK Editor
//
//  Created by Ian Sidor on 08/11/2011.
//  Copyright (c) 2011 Banana Iguana. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RomRange.h"

// REF	:	http://datacrystal.romhacking.net/wiki/Super_Mario_Kart:ROM_map
//		:	http://www.gdward.plus.com/site/gaming/docs/smk.txt
//		:	http://www.snesmaps.com/maps/SuperMarioKart/SuperMarioKartMapSelect.html

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
