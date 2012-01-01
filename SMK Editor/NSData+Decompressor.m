//
//  NSData+Decompressor.m
//  SMK Editor
//
//  Created by Ian Sidor on 08/11/2011.
//  Copyright (c) 2011 Banana Iguana. All rights reserved.
//

#import "NSData+Decompressor.h"

// The maximum data size is 0x40000 for any data that will be required for decompression AFAIK. If at any point
// the app actually restructures the ROM (highly unlikely) then this value may change.

#define NSDATA_DECOMPRESSOR_BUFFER_MAX						0x40000

// Compression methods

#define NSDATA_DECOMPRESSOR_COMMAND_NO_COMPRESSION			0		// Simple range copy, no compression
#define NSDATA_DECOMPRESSOR_COMMAND_COPY_SINGLE				1		// Read single source byte, copy to destination for range.
#define NSDATA_DECOMPRESSOR_COMMAND_COPY_DOUBLE				2		// Read two source bytes, copy to destination for range.
#define NSDATA_DECOMPRESSOR_COMMAND_COPY_SINGLE_INC			3		// Read single source byte, copy to destination for range, incrementing source after each write
#define NSDATA_DECOMPRESSOR_COMMAND_COPY_OFFSET				4		// Read short (2 bytes) and recopy to destination from that offset.
#define NSDATA_DECOMPRESSOR_COMMAND_COPY_OFFSET_XOR			5		// Read short (2 bytes) and recopy with XOR to destination from that offset.
#define NSDATA_DECOMPRESSOR_COMMAND_COPY_OFFSET_DEST		6		// Read byte, subtract from destination and duplicate from that point.
#define NSDATA_DECOMPRESSOR_COMMAND_EXTEND					7		// Extend the byte count.

// For ease of use, the compressor is categorised against an NSData object. Once you have the ROM held in an NSData
// structure, one call is all you need to acquire your data.

@implementation NSData (Decompressor)

// The code below is an Objective-C version of a piece of Java code I wrote years ago. I didn't leave any notes in
// the original code so I have limited memory of how I worked through this algorithm. I vaugely remember using a
// document that somebody published online to decompress graphics from Super Mario World. I also remember speaking
// to someone via email who had previously worked on a Super Mario Kart mod.

// (Creditation updated:)
//
// http://smkdan.eludevisibility.org/smk.html

-(NSData*)decompressRange:(NSRange)range
{
	unsigned char sourceData[ NSDATA_DECOMPRESSOR_BUFFER_MAX ];
	unsigned char decompressionBuffer[ NSDATA_DECOMPRESSOR_BUFFER_MAX ];
	
	range.length = MIN( range.length, NSDATA_DECOMPRESSOR_BUFFER_MAX );
	
	[self getBytes:sourceData range:range];
	
	NSInteger destinationPosition = 0, sourcePosition = 0;
	unsigned char cmd;

	while( ( cmd = sourceData[ sourcePosition++ ] ) != 0xFF )
	{
		unsigned char ctrl = (unsigned char)( ( cmd & 0xE0 ) >> 5 );
		NSInteger count;
		
		if( ( ctrl != NSDATA_DECOMPRESSOR_COMMAND_EXTEND ) && ( cmd < 0xE0 ) )
		{
			count = ( cmd & 0x1F );
		}
		else
		{
			ctrl = (unsigned char)( ( cmd & 0x1C ) >> 2 );
			count = ( ( ( ( cmd & 0x3 ) << 8 ) & 0xFF00 ) | ( ( sourceData[ sourcePosition++ ] ) & 0xFF ) );
		}
		
		count++;
		
		switch( ctrl )
		{
			case NSDATA_DECOMPRESSOR_COMMAND_NO_COMPRESSION :
				{
					for( NSInteger i = 0; i < count; i++ )
					{
						decompressionBuffer[ destinationPosition++ ] = sourceData[ sourcePosition++ ];
					}
					
				}break;
				
			case NSDATA_DECOMPRESSOR_COMMAND_COPY_SINGLE :
				{
					for( NSInteger i = 0; i < count; i++ )
					{
						decompressionBuffer[ destinationPosition++ ] = sourceData[ sourcePosition ];
					}
					
					sourcePosition++;
					
				}break;
				
			case NSDATA_DECOMPRESSOR_COMMAND_COPY_DOUBLE :
				{
					NSInteger j = 0;
					
					for( NSInteger i = 0; i < count; i++ )
					{
						decompressionBuffer[ destinationPosition++ ] = sourceData[ sourcePosition + j ];
						
						j = 1 - j;
					}
					
					sourcePosition += 2;
					
				}break;
				
			case NSDATA_DECOMPRESSOR_COMMAND_COPY_SINGLE_INC :
				{
					for( NSInteger i = 0; i < count; i++ )
					{
						NSInteger temp = ( ( sourceData[ sourcePosition ] + i ) & 0xFF ) % 256;
													
						decompressionBuffer[ destinationPosition++ ] = (unsigned char)temp;
					}
					
					sourcePosition++;
					
				}break;
				
			case NSDATA_DECOMPRESSOR_COMMAND_COPY_OFFSET :
				{
					NSInteger byte1 = sourceData[ sourcePosition++ ] & 0xFF;
					NSInteger byte2 = sourceData[ sourcePosition++ ] & 0xFF;
											
					NSInteger srcPosition = ( ( byte1 ) | ( byte2 << 8 ) );
					
					for( NSInteger i = 0; i < count; i++ )
					{
						decompressionBuffer[ destinationPosition++ ] = decompressionBuffer[ srcPosition + i ];
					}
					
				}break;

			case NSDATA_DECOMPRESSOR_COMMAND_COPY_OFFSET_XOR :
				{
					NSInteger byte1 = sourceData[ sourcePosition++ ] & 0xFF;
					NSInteger byte2 = sourceData[ sourcePosition++ ] & 0xFF;
					
					NSInteger srcPosition = ( byte1 ) | ( byte2 << 8 );
					
					for( NSInteger i = 0; i < count; i++ )
					{
						NSInteger temp = ( decompressionBuffer[ srcPosition + i ] & 0xFF ) ^ 0xFF;
						
						decompressionBuffer[ destinationPosition++ ] = (unsigned char)temp;
					}
					
				}break;
				
			case NSDATA_DECOMPRESSOR_COMMAND_COPY_OFFSET_DEST :
				{
					NSInteger byteData = sourceData[ sourcePosition++ ] & 0xFF;
					
					NSInteger srcPosition = destinationPosition - byteData;
					
					for( NSInteger i = 0; i < count; i++ )
					{
						decompressionBuffer[ destinationPosition++ ] = decompressionBuffer[ srcPosition++ ];
					}
					
				}break;
				
			default:
				{
					// Corruption ? // Error ?
					
					NSAssert( 0, @"Unhandled state encountered while decompressing" );
				}
		}
	}
	
	NSData *returnData = [NSData dataWithBytes:decompressionBuffer length:destinationPosition];

	return( returnData );
}

-(NSData*)decompressTrackRange:(NSRange)range
{
	NSData *decompressedData			= [self decompressRange:range];

	NSRange newRange					= NSMakeRange( 0, decompressedData.length );

	NSData *trackData					= [decompressedData decompressRange:newRange];
	
	return( trackData );
}

@end
