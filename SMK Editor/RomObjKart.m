//
//  RomObjKart.m
//  SMK Editor
//
//  Created by Ian Sidor on 06/01/2012.
//  Copyright (c) 2012 Banana Iguana. All rights reserved.
//

#import "RomObjKart.h"

@implementation RomObjKart

+(unsigned short int)processBitplaneForMask:(unsigned int)mask plane1:(unsigned char)p1 plane2:(unsigned char)p2 plane3:(unsigned char)p3 plane4:(unsigned char)p4
{
	unsigned short int ret				=	( ( p1 & mask ) << 0 ) |
											( ( p2 & mask ) << 1 ) |
											( ( p3 & mask ) << 2 ) |
											( ( p4 & mask ) << 3 );
											
	return( ret );
}

//		Bytes

//		0		1		2		3		4		5		6		7
//		8		9		10		11		12		13		14		15
//		16		17		18		19		20		21		22		23
//		24		25		26		27		28		29		30		31

//		Pixels
//
//						col 1							col 2
//
//	row 1		[0, 1, 16,17] & 0x80			[0, 1, 16,17] & 0x40		.. etc
//	row 2		[2, 3, 18,19] & 0x80			[2, 3, 18,19] & 0x40
//	row 3		[4, 5, 20,21] & 0x80			[4, 5, 20,21] & 0x40
//	row 4		[6, 7, 22,23] & 0x80			[6, 7, 22,23] & 0x40
//	row 5		[8, 9, 24,25] & 0x80			[8, 9, 24,25] & 0x40
//	row 6		[10,11,26,27] & 0x80			[10,11,26,27] & 0x40
//	row 7		[12,13,28,29] & 0x80			[12,13,28,29] & 0x40
//	row 8		[14,15,30,31] & 0x80			[14,15,30,31] & 0x40

-(NSData*)processTile:(unsigned char*)tile32bytes
{
	unsigned char *p					= tile32bytes;
	unsigned int columnMask[ 8 ]		= { 0x80, 0x40, 0x20, 0x10, 0x08, 0x04, 0x02, 0x01 };

	unsigned short int indexGrid[ 8 ][ 8 ];		// Row Major
	unsigned int j;

	for( int i = 0; i < 8; ++i )
	{
		j								= 0;

		indexGrid[ i ][ j++ ]			= [RomObjKart processBitplaneForMask:columnMask[ i ] plane1:p[ 0x00 ] plane2:p[ 0x01 ] plane3:p[ 0x10 ] plane4:p[ 0x11 ]];
		indexGrid[ i ][ j++ ]			= [RomObjKart processBitplaneForMask:columnMask[ i ] plane1:p[ 0x02 ] plane2:p[ 0x03 ] plane3:p[ 0x12 ] plane4:p[ 0x13 ]];
		indexGrid[ i ][ j++ ]			= [RomObjKart processBitplaneForMask:columnMask[ i ] plane1:p[ 0x04 ] plane2:p[ 0x05 ] plane3:p[ 0x14 ] plane4:p[ 0x15 ]];
		indexGrid[ i ][ j++ ]			= [RomObjKart processBitplaneForMask:columnMask[ i ] plane1:p[ 0x06 ] plane2:p[ 0x07 ] plane3:p[ 0x16 ] plane4:p[ 0x17 ]];

		indexGrid[ i ][ j++ ]			= [RomObjKart processBitplaneForMask:columnMask[ i ] plane1:p[ 0x08 ] plane2:p[ 0x09 ] plane3:p[ 0x18 ] plane4:p[ 0x19 ]];
		indexGrid[ i ][ j++ ]			= [RomObjKart processBitplaneForMask:columnMask[ i ] plane1:p[ 0x0A ] plane2:p[ 0x0B ] plane3:p[ 0x1A ] plane4:p[ 0x1B ]];
		indexGrid[ i ][ j++ ]			= [RomObjKart processBitplaneForMask:columnMask[ i ] plane1:p[ 0x0C ] plane2:p[ 0x0D ] plane3:p[ 0x1C ] plane4:p[ 0x1D ]];
		indexGrid[ i ][ j++ ]			= [RomObjKart processBitplaneForMask:columnMask[ i ] plane1:p[ 0x0E ] plane2:p[ 0x0F ] plane3:p[ 0x1E ] plane4:p[ 0x1F ]];
	}
	
	NSData *indexData					= [[[NSData alloc] initWithBytes:indexGrid length:( sizeof( unsigned short int ) * 8 * 8 )] autorelease];
	
	return( indexData );
}

-(void)setup
{
	int i								= 0;
	NSRange range						= self.dataRange.range;
	
	while( i < range.length )
	{
		unsigned char tile[ 32 ];
		
		[self.data getBytes:tile range:NSMakeRange( i + range.location, 32 )];
		
		[self processTile:tile];

		i								+= 32;
	}
}

@end
