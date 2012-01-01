//
//  NSData+Decompressor.h
//  SMK Editor
//
//  Created by Ian Sidor on 08/11/2011.
//  Copyright (c) 2011 Banana Iguana. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Decompressor)

-(NSData*)decompressRange:(NSRange)range;
-(NSData*)decompressTrackRange:(NSRange)range;

@end
