//
//  RomBase+Info.m
//  SMK Editor
//
//  Created by Ian Sidor on 26/11/2012.
//  Copyright (c) 2012 Banana Iguana. All rights reserved.
//

#import "RomBase+Info.h"

//	All information within this file is obtained from this URL: http://www.romhacking.net/documents/232/
//	Many thanks to 'DiskDude' for submitting this detailed information regarding the SNES ROM.

@implementation RomBase (Info)

-(unsigned char)byteFromOffsetHandle:(kRomHandle)handle
{
	NSNumber *value								= [self objectFromHandle:handle];
	
//	NSAssert( [value objCType] == @encode(unsigned char), @"Unexpected encoding on NSNumber Objective-C type, this may fail..." );

	return( [value unsignedCharValue] );
}

-(NSString*)country
{
	unsigned char byte							= [self byteFromOffsetHandle:kRomHandleDestinationCodeOffset];

	switch( byte )
	{
		case 0x0 :	{			return( @"Japan" );											}break;
		case 0x1 :	{			return( @"USA" );											}break;
		case 0x2 :	{			return( @"Australia, Europe, Oceania & Asia" );				}break;
		case 0x3 :	{			return( @"Sweden" );										}break;
		case 0x4 :	{			return( @"Finland" );										}break;
		case 0x5 :	{			return( @"Denmark" );										}break;
		case 0x6 :	{			return( @"France" );										}break;
		case 0x7 :	{			return( @"Holland" );										}break;
		case 0x8 :	{			return( @"Spain" );											}break;
		case 0x9 :	{			return( @"Germany, Austria & Switzerland" );				}break;
		case 0xA :	{			return( @"Italy" );											}break;
		case 0xB :	{			return( @"Hong Kong & China" );								}break;
		case 0xC :	{			return( @"Indonesia" );										}break;
		case 0xD :	{			return( @"Korea" );											}break;
		default :
			{
				NSAssert( 0, @"Unknown country code detected in ROM data." );
			}
	}
				
	return( @"Unknown" );
}

-(NSString*)licencee
{
	unsigned char byte							= [self byteFromOffsetHandle:kRomHandleLicenseeCodeOffset];
	
	switch( byte )
	{
		case   1 :	{			return( @"Nintendo" );										}break;
		case   3 :	{			return( @"Imagineer-Zoom" );								}break;
		case   5 :	{			return( @"Zamuse" );										}break;
		case   6 :	{			return( @"Falcom" );										}break;
		case   8 :	{			return( @"Capcom" );										}break;
		case   9 :	{			return( @"HOT-B" );											}break;
		case  10 :	{			return( @"Jaleco" );										}break;
		case  11 :	{			return( @"Coconuts" );										}break;
		case  12 :	{			return( @"Rage Software" );									}break;
		case  14 :	{			return( @"Technos" );										}break;
		case  15 :	{			return( @"Mebio Software" );								}break;
		case  18 :	{			return( @"Gremlin Graphics" );								}break;
		case  19 :	{			return( @"Electronic Arts" );								}break;
		case  21 :	{			return( @"COBRA Team" );									}break;
		case  22 :	{			return( @"Human/Field" );									}break;
		case  23 :	{			return( @"KOEI" );											}break;
		case  24 :	{			return( @"Hudson Soft" );									}break;
		case  26 :	{			return( @"Yanoman" );										}break;
		case  28 :	{			return( @"Tecmo" );											}break;
		case  30 :	{			return( @"Open System" );									}break;
		case  31 :	{			return( @"Virgin Games" );									}break;
		case  32 :	{			return( @"KSS" );											}break;
		case  33 :	{			return( @"Sunsoft" );										}break;
		case  34 :	{			return( @"POW" );											}break;
		case  35 :	{			return( @"Micro World" );									}break;
		case  38 :	{			return( @"Enix" );											}break;
		case  39 :	{			return( @"Loriciel/Electro Brain" );						}break;
		case  40 :	{			return( @"Kemco" );											}break;
		case  41 :	{			return( @"Seta Co.,Ltd." );									}break;
		case  45 :	{			return( @"Visit Co.,Ltd." );								}break;
		case  49 :	{			return( @"Carrozzeria" );									}break;
		case  50 :	{			return( @"Dynamic" );										}break;
		case  51 :	{			return( @"Nintendo" );										}break;
		case  52 :	{			return( @"Magifact" );										}break;
		case  53 :	{			return( @"Hect" );											}break;
		case  60 :	{			return( @"Empire Software" );								}break;
		case  61 :	{			return( @"Loriciel" );										}break;
		case  64 :	{			return( @"Seika Corp." );									}break;
		case  65 :	{			return( @"UBI Soft" );										}break;
		case  70 :	{			return( @"System 3" );										}break;
		case  71 :	{			return( @"Spectrum Holobyte" );								}break;
		case  73 :	{			return( @"Irem" );											}break;
		case  75 :	{			return( @"Raya Systems/Sculptured Software" );				}break;
		case  76 :	{			return( @"Renovation Products" );							}break;
		case  77 :	{			return( @"Malibu Games/Black Pearl" );						}break;
		case  79 :	{			return( @"U.S. Gold" );										}break;
		case  80 :	{			return( @"Absolute Entertainment" );						}break;
		case  81 :	{			return( @"Acclaim" );										}break;
		case  82 :	{			return( @"Activision" );									}break;
		case  83 :	{			return( @"American Sammy" );								}break;
		case  84 :	{			return( @"GameTek" );										}break;
		case  85 :	{			return( @"Hi Tech Expressions" );							}break;
		case  86 :	{			return( @"LJN Toys" );										}break;
		case  90 :	{			return( @"Mindscape" );										}break;
		case  93 :	{			return( @"Tradewest" );										}break;
		case  95 :	{			return( @"American Softworks Corp." );						}break;
		case  96 :	{			return( @"Titus" );											}break;
		case  97 :	{			return( @"Virgin Interactive Entertainment" );				}break;
		case  98 :	{			return( @"Maxis" );											}break;
		case 103 :	{			return( @"Ocean" );											}break;
		case 105 :	{			return( @"Electronic Arts" );								}break;
		case 107 :	{			return( @"Laser Beam" );									}break;
		case 110 :	{			return( @"Elite" );											}break;
		case 111 :	{			return( @"Electro Brain" );									}break;
		case 112 :	{			return( @"Infogrames" );									}break;
		case 113 :	{			return( @"Interplay" );										}break;
		case 114 :	{			return( @"LucasArts" );										}break;
		case 115 :	{			return( @"Parker Brothers" );								}break;
		case 117 :	{			return( @"STORM" );											}break;
		case 120 :	{			return( @"THQ Software" );									}break;
		case 121 :	{			return( @"Accolade Inc." );									}break;
		case 122 :	{			return( @"Triffix Entertainment" );							}break;
		case 124 :	{			return( @"Microprose" );									}break;
		case 127 :	{			return( @"Kemco" );											}break;
		case 128 :	{			return( @"Misawa" );										}break;
		case 129 :	{			return( @"Teichio" );										}break;
		case 130 :	{			return( @"Namco Ltd." );									}break;
		case 131 :	{			return( @"Lozc" );											}break;
		case 132 :	{			return( @"Koei" );											}break;
		case 134 :	{			return( @"Tokuma Shoten Intermedia" );						}break;
		case 136 :	{			return( @"DATAM-Polystar" );								}break;
		case 139 :	{			return( @"Bullet-Proof Software" );							}break;
		case 140 :	{			return( @"Vic Tokai" );										}break;
		case 142 :	{			return( @"Character Soft" );								}break;
		case 143 :	{			return( @"I''Max" );										}break;
		case 144 :	{			return( @"Takara" );										}break;
		case 145 :	{			return( @"CHUN Soft" );										}break;
		case 146 :	{			return( @"Video System Co., Ltd." );						}break;
		case 147 :	{			return( @"BEC" );											}break;
		case 149 :	{			return( @"Varie" );											}break;
		case 151 :	{			return( @"Kaneco" );										}break;
		case 153 :	{			return( @"Pack in Video" );									}break;
		case 154 :	{			return( @"Nichibutsu" );									}break;
		case 155 :	{			return( @" TECMO" );										}break;
		case 156 :	{			return( @"Imagineer Co." );									}break;
		case 160 :	{			return( @"Telenet" );										}break;
		case 164 :	{			return( @"Konami" );										}break;
		case 165 :	{			return( @"K.Amusement Leasing Co." );						}break;
		case 167 :	{			return( @"Takara" );										}break;
		case 169 :	{			return( @"Technos Jap." );									}break;
		case 170 :	{			return( @"JVC" );											}break;
		case 172 :	{			return( @"Toei Animation" );								}break;
		case 173 :	{			return( @"Toho" );											}break;
		case 175 :	{			return( @"Namco Ltd." );									}break;
		case 177 :	{			return( @"ASCII Co. Activison" );							}break;
		case 178 :	{			return( @"BanDai America" );								}break;
		case 180 :	{			return( @"Enix" );											}break;
		case 182 :	{			return( @"Halken" );										}break;
		case 186 :	{			return( @"Culture Brain" );									}break;
		case 187 :	{			return( @"Sunsoft" );										}break;
		case 188 :	{			return( @"Toshiba EMI" );									}break;
		case 189 :	{			return( @"Sony Imagesoft" );								}break;
		case 191 :	{			return( @"Sammy" );											}break;
		case 192 :	{			return( @"Taito" );											}break;
		case 194 :	{			return( @"Kemco" );											}break;
		case 195 :	{			return( @"Square" );										}break;
		case 196 :	{			return( @"Tokuma Soft" );									}break;
		case 197 :	{			return( @"Data East" );										}break;
		case 198 :	{			return( @"Tonkin House" );									}break;
		case 200 :	{			return( @"KOEI" );											}break;
		case 202 :	{			return( @"Konami USA" );									}break;
		case 203 :	{			return( @"NTVIC" );											}break;
		case 205 :	{			return( @"Meldac" );										}break;
		case 206 :	{			return( @"Pony Canyon" );									}break;
		case 207 :	{			return( @"Sotsu Agency/Sunrise" );							}break;
		case 208 :	{			return( @"Disco/Taito" );									}break;
		case 209 :	{			return( @"Sofel" );											}break;
		case 210 :	{			return( @"Quest Corp." );									}break;
		case 211 :	{			return( @"Sigma" );											}break;
		case 214 :	{			return( @"Naxat" );											}break;
		case 216 :	{			return( @"Capcom Co., Ltd." );								}break;
		case 217 :	{			return( @"Banpresto" );										}break;
		case 218 :	{			return( @"Tomy" );											}break;
		case 219 :	{			return( @"Acclaim" );										}break;
		case 221 :	{			return( @"NCS" );											}break;
		case 222 :	{			return( @"Human Entertainment" );							}break;
		case 223 :	{			return( @"Altron" );										}break;
		case 224 :	{			return( @"Jaleco" );										}break;
		case 226 :	{			return( @"Yutaka" );										}break;
		case 228 :	{			return( @"T&ESoft" );										}break;
		case 229 :	{			return( @"EPOCH Co.,Ltd." );								}break;
		case 231 :	{			return( @"Athena" );										}break;
		case 232 :	{			return( @" Asmik" );										}break;
		case 233 :	{			return( @"Natsume" );										}break;
		case 234 :	{			return( @"King Records" );									}break;
		case 235 :	{			return( @"Atlus" );											}break;
		case 236 :	{			return( @"Sony Music Entertainment" );						}break;
		case 238 :	{			return( @"IGS" );											}break;
		case 241 :	{			return( @"Motown Software" );								}break;
		case 242 :	{			return( @"Left Field Entertainment" );						}break;
		case 243 :	{			return( @"Beam Software" );									}break;
		case 244 :	{			return( @"Tec Magik" );										}break;
		case 249 :	{			return( @"Cybersoft" );										}break;
		case 255 :	{			return( @"Hudson Soft" );									}break;

		default :
			{
				NSAssert( 0, @"Unknown country code detected in ROM data." );
			}
	}
				
	return( @"Unknown" );		
};

@end
