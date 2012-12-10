//
//  RomRange.h
//  SMK Editor
//
//  Created by Ian Sidor on 08/11/2011.
//  Copyright (c) 2011 Banana Iguana. All rights reserved.
//

#ifndef _ROMRANGE_H_
#define _ROMRANGE_H_

typedef enum kRomRangeType
{
	kRomRangeTypeString,
	kRomRangeTypeUnsignedChar,
	kRomRangeTypeEncodedString,
	kRomRangeTypeCompressedData,
	kRomRangeTypePaletteGroup,
	kRomRangeTypePalette,
	kRomRangeTypeTileGroup,
	kRomRangeTypeTile,
	kRomRangeTypeTrack,
	kRomRangeTypeAIZone,
	kRomRangeTypeAITarget,
	kRomRangeTypeKart,
	
	kRomRangeNumTypes,
	
}kRomRangeType;

typedef struct RomRange
{
	NSRange				range;
	NSUInteger			max;
	kRomRangeType		type;

}RomRange;

static RomRange RomRangeMakeFull( kRomRangeType type, NSUInteger offset, NSUInteger length, NSUInteger max )\
{\
    RomRange			r;\
	r.type				= type;\
	r.range				= NSMakeRange( offset, length );\
    r.max				= max;\
    return( r );\
}

static RomRange RomRangeMake( kRomRangeType type, NSUInteger offset, NSUInteger length )\
{\
    RomRange			r;\
	r.type				= type;\
    r.range				= NSMakeRange( offset, length );\
    r.max				= length;\
    return( r );\
}

#endif // _ROMRANGE_H_
