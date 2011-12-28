//
//  RomTypes.h
//  SMK Editor
//
//  Created by Ian Sidor on 13/11/2011.
//  Copyright (c) 2011 Banana Iguana. All rights reserved.
//

#ifndef _ROMTYPES_H_
#define _ROMTYPES_H_

typedef enum kRomTheme
{
	kRomThemeGhostValley,			// 0
	kRomThemeMarioCircuit,			// 1
	kRomThemeDonutPlains,			// 2
	kRomThemeChocoIsland,			// 3
	kRomThemeVanillaLake,			// 4
	kRomThemeKoopaBeach,			// 5
	kRomThemeBowserCastle,			// 6
	kRomThemeRainbowRoad,			// 7
	
	kRomNumThemes

}kRomTheme;

static inline NSString *RomThemeToString( kRomTheme theme )
{
	switch( theme )
	{
		case kRomThemeGhostValley :		{ return( @"Ghost Valley" );	}break;
		case kRomThemeMarioCircuit :	{ return( @"Mario Circuit" );	}break;
		case kRomThemeDonutPlains :		{ return( @"Donut Plains" );	}break;
		case kRomThemeChocoIsland :		{ return( @"Choco Island" );	}break;
		case kRomThemeVanillaLake :		{ return( @"Vanilla Lake" );	}break;
		case kRomThemeKoopaBeach :		{ return( @"Koopa Beach" );		}break;
		case kRomThemeBowserCastle :	{ return( @"Bowser Castle" );	}break;
		case kRomThemeRainbowRoad :		{ return( @"Rainbow Road" );	}break;
		
		default :						{ return( @"Unknown" );			}		
	}
}

#endif // _ROMTYPES_H_
