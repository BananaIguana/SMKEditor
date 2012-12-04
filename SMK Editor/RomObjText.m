//
//  RomObjText.m
//  SMK Editor
//
//  Created by Ian Sidor on 08/11/2011.
//  Copyright (c) 2011 Banana Iguana. All rights reserved.
//

#import "RomObjText.h"
	
#define ROMOBJTEXT_BUFFER_MAX				256

@implementation RomObjText

-(void)decodeCharacter:(char*)character
{
	switch( *character )
	{
		case 0x00 : *character = '0';	break;
		case 0x01 : *character = '1';	break;
		case 0x02 : *character = '2';	break;
		case 0x03 : *character = '3';	break;
		case 0x04 : *character = '4';	break;
		case 0x05 : *character = '5';	break;
		case 0x06 : *character = '6';	break;
		case 0x07 : *character = '7';	break;
		case 0x08 : *character = '8';	break;
		case 0x09 : *character = '9';	break;
		case 0x0a : *character = 'A';	break;
		case 0x0b : *character = 'B';	break;
		case 0x0c : *character = 'C';	break;
		case 0x0d : *character = 'D';	break;
		case 0x0e : *character = 'E';	break;
		case 0x0f : *character = 'F';	break;
		case 0x10 : *character = 'G';	break;
		case 0x11 : *character = 'H';	break;
		case 0x12 : *character = 'I';	break;
		case 0x13 : *character = 'J';	break;
		case 0x14 : *character = 'K';	break;
		case 0x15 : *character = 'L';	break;
		case 0x16 : *character = 'M';	break;
		case 0x17 : *character = 'N';	break;
		case 0x18 : *character = 'O';	break;
		case 0x19 : *character = 'P';	break;
		case 0x1a : *character = 'Q';	break;
		case 0x1b : *character = 'R';	break;
		case 0x1c : *character = 'S';	break;
		case 0x1d : *character = 'T';	break;
		case 0x1e : *character = 'U';	break;
		case 0x1f : *character = 'V';	break;
		case 0x20 : *character = 'W';	break;
		case 0x21 : *character = 'X';	break;
		case 0x22 : *character = 'Y';	break;
		case 0x23 : *character = 'Z';	break;
		case 0x24 : *character = '?';	break;
		case 0x25 : *character = '.';	break;
		case 0x26 : *character = ',';	break;
		case 0x27 : *character = '!';	break;
		case 0x28 : *character = '\'';	break;
		case 0x29 : *character = '"';	break;
		case 0x2c : *character = ' ';	break;
		
		default : *character =  '?'; 	break;
	}
}

-(void)decodeBuffer:(char*)buffer length:(NSUInteger)length
{
	char *current = buffer;
	
	for( NSUInteger i = 0; i < length; ++i, ++current )
	{
		[self decodeCharacter:current];
	}
}

-(void)setup
{
	char buffer[ ROMOBJTEXT_BUFFER_MAX ];
	
	NSRange range = self.dataRange.range;
	
	range.length = MIN( range.length, ROMOBJTEXT_BUFFER_MAX );

	[self.data getBytes:buffer range:range];
	
	buffer[ range.length ] = 0;
	
	[self decodeBuffer:buffer length:range.length];
	
	self.text = [NSString stringWithCString:buffer encoding:NSStringEncodingConversionAllowLossy];
}

-(NSString*)description
{
	return( self.text );
}

@end
