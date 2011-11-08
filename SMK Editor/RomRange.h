//
//  RomRange.h
//  SMK Editor
//
//  Created by Ian Sidor on 08/11/2011.
//  Copyright (c) 2011 Roar Technology. All rights reserved.
//

#ifndef _ROMRANGE_H_
#define _ROMRANGE_H_

#import "RomRef.h"

typedef struct RomRange
{
	NSRange			range;
	NSUInteger		max;
	kRomRefType		type;

}RomRange;

static RomRange RomRangeMakeFull( kRomRefType type, NSUInteger offset, NSUInteger length, NSUInteger max )\
{\
    RomRange		r;\
	r.type			= type;\
	r.range			= NSMakeRange( offset, length );\
    r.max			= max;\
    return( r );\
}

static RomRange RomRangeMake( kRomRefType type, NSUInteger offset, NSUInteger length )\
{\
    RomRange		r;\
	r.type			= type;\
    r.range			= NSMakeRange( offset, length );\
    r.max			= length;\
    return( r );\
}

#endif // _ROMRANGE_H_
