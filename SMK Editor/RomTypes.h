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
	kRomThemeGhostValley,			// Index 0
	kRomThemeMarioCircuit,			// Index 1
	kRomThemeDonutPlains,			// Index 2
	kRomThemeChocoIsland,			// Index 3
	kRomThemeVanillaLake,			// Index 4
	kRomThemeKoopaBeach,			// Index 5
	kRomThemeBowserCastle,			// Index 6
	kRomThemeRainbowRoad,			// Index 7
	
	kRomNumThemes

}kRomTheme;

typedef enum kRomTrack
{
	kRomTrackMarioCircuit3,			// Index 00 - Flower Cup Race 5
	kRomTrackGhostValley2,			// Index 01 - Flower Cup Race 2
	kRomTrackDohnutPlains2,			// Index 02 - Flower Cup Race 3
	kRomTrackBowserCastle2,			// Index 03 - Flower Cup Race 4
	kRomTrackVanillaLake2,			// Index 04 - Special Cup Race 4
	kRomTrackRainbowRoad,			// Index 05 - Special Cup Race 5
	kRomTrackKoopaBeach2,			// Index 06 - Special Cup Race 2
	kRomTrackMarioCircuit1,			// Index 07 - Mushroom Cup Race 1
	kRomTrackGhostValley3,			// Index 08 - Special Cup Race 3
	kRomTrackBowserCastle3,			// Index 09 - Star Cup Race 4
	kRomTrackChocoIsland2,			// Index 10 - Star Cup Race 2
	kRomTrackDohnutPlains3,			// Index 11 - Special Cup Race 1
	kRomTrackVanillaLake1,			// Index 12 - Star Cup Race 3
	kRomTrackKoopaBeach1,			// Index 13 - Star Cup Race 1
	kRomTrackMarioCircuit4,			// Index 14 - Star Cup Race 5
	kRomTrackMarioCircuit2,			// Index 15 - Mushroom Cup Race 5
	kRomTrackGhostValley1,			// Index 16 - Mushroom Cup Race 3
	kRomTrackBowserCastle1,			// Index 17 - Mushroom Cup Race 4
	kRomTrackChocoIsland1,			// Index 18 - Flower Cup Race 1
	kRomTrackDohnutPlains1,			// Index 19 - Mushroom Cup Race 2
	kRomTrackBattleCourse3,			// Index 20
	kRomTrackBattleCourse4,			// Index 21
	kRomTrackBattleCourse1,			// Index 22
	kRomTrackBattleCourse2,			// Index 23
	
	kRomNumTracks,
	
	kRomNumTrackBattleCourses		= kRomNumTracks - kRomTrackBattleCourse3,

	kRomNumTrackGPTracks			= kRomNumTracks - kRomNumTrackBattleCourses,
	
}kRomTrack;

typedef enum kRomAIData
{
	kRomAIDataMarioCircuit3,		// Index 00 - Flower Cup Race 5
	kRomAIDataGhostValley2,			// Index 01 - Flower Cup Race 2
	kRomAIDataDohnutPlains2,		// Index 02 - Flower Cup Race 3
	kRomAIDataBowserCastle2,		// Index 03 - Flower Cup Race 4
	kRomAIDataVanillaLake2,			// Index 04 - Special Cup Race 4
	kRomAIDataRainbowRoad,			// Index 05 - Special Cup Race 5
	kRomAIDataKoopaBeach2,			// Index 06 - Special Cup Race 2
	kRomAIDataMarioCircuit1,		// Index 07 - Mushroom Cup Race 1
	kRomAIDataGhostValley3,			// Index 08 - Special Cup Race 3
	kRomAIDataBowserCastle3,		// Index 09 - Star Cup Race 4
	kRomAIDataChocoIsland2,			// Index 10 - Star Cup Race 2
	kRomAIDataDohnutPlains3,		// Index 11 - Special Cup Race 1
	kRomAIDataVanillaLake1,			// Index 12 - Star Cup Race 3
	kRomAIDataKoopaBeach1,			// Index 13 - Star Cup Race 1
	kRomAIDataMarioCircuit4,		// Index 14 - Star Cup Race 5
	kRomAIDataMarioCircuit2,		// Index 15 - Mushroom Cup Race 5
	kRomAIDataGhostValley1,			// Index 16 - Mushroom Cup Race 3
	kRomAIDataBowserCastle1,		// Index 17 - Mushroom Cup Race 4
	kRomAIDataChocoIsland1,			// Index 18 - Flower Cup Race 1
	kRomAIDataDohnutPlains1,		// Index 19 - Mushroom Cup Race 2
	
	kRomNumAIData,

}kRomAIData;

typedef enum kRomKart
{
	kRomKartMario,					// Index 0
	kRomKartBowser,					// Index 1
	kRomKartPrincess,				// Index 2
	kRomKartKong,					// Index 3
	kRomKartYoshi,					// Index 4
	kRomKartLuigi,					// Index 5
	kRomKartKoopa,					// Index 6
	kRomKartToad,					// Index 7
	
	kRomNumKarts,

}kRomKart;

static inline NSString *RomThemeToString( kRomTheme theme )
{
	switch( theme )
	{
		case kRomThemeGhostValley :			{ return( @"Ghost Valley" );		}break;
		case kRomThemeMarioCircuit :		{ return( @"Mario Circuit" );		}break;
		case kRomThemeDonutPlains :			{ return( @"Donut Plains" );		}break;
		case kRomThemeChocoIsland :			{ return( @"Choco Island" );		}break;
		case kRomThemeVanillaLake :			{ return( @"Vanilla Lake" );		}break;
		case kRomThemeKoopaBeach :			{ return( @"Koopa Beach" );			}break;
		case kRomThemeBowserCastle :		{ return( @"Bowser Castle" );		}break;
		case kRomThemeRainbowRoad :			{ return( @"Rainbow Road" );		}break;
		
		default :							{ return( @"Unknown" );				}		
	}
}

static inline NSString *RomTrackToString( kRomTrack track )
{
	switch( track )
	{
		case kRomTrackMarioCircuit3 :		{ return( @"Mario Circuit 3" );		}break;
		case kRomTrackGhostValley2 :		{ return( @"Ghost Valley 2" );		}break;
		case kRomTrackDohnutPlains2 :		{ return( @"Donut Plains 2" );		}break;
		case kRomTrackBowserCastle2 :		{ return( @"Bowser Castle 2" );		}break;
		case kRomTrackVanillaLake2 :		{ return( @"Vanilla Lake 2" );		}break;
		case kRomTrackRainbowRoad :			{ return( @"Rainbow Road" );		}break;
		case kRomTrackKoopaBeach2 :			{ return( @"Koopa Beach 2" );		}break;
		case kRomTrackMarioCircuit1 :		{ return( @"Mario Circuit 1" );		}break;
		case kRomTrackGhostValley3 :		{ return( @"Ghost Valley 3" );		}break;
		case kRomTrackBowserCastle3 :		{ return( @"Bowser Castle 3" );		}break;
		case kRomTrackChocoIsland2 :		{ return( @"Choch Island 2" );		}break;
		case kRomTrackDohnutPlains3 :		{ return( @"Donut Plains 3" );		}break;
		case kRomTrackVanillaLake1 :		{ return( @"Vanilla Lake 1" );		}break;
		case kRomTrackKoopaBeach1 :			{ return( @"Koopa Beach 1" );		}break;
		case kRomTrackMarioCircuit4 :		{ return( @"Mario Circuit 4" );		}break;
		case kRomTrackMarioCircuit2 :		{ return( @"Mario Circuit 2" );		}break;
		case kRomTrackGhostValley1 :		{ return( @"Ghost Valley 1" );		}break;
		case kRomTrackBowserCastle1 :		{ return( @"Bowser Castle 1" );		}break;
		case kRomTrackChocoIsland1 :		{ return( @"Choco Island 1" );		}break;
		case kRomTrackDohnutPlains1 :		{ return( @"Donut Plains 1" );		}break;
		case kRomTrackBattleCourse3 :		{ return( @"Battle Course 3" );		}break;
		case kRomTrackBattleCourse4 :		{ return( @"Battle Course 4" );		}break;
		case kRomTrackBattleCourse1 :		{ return( @"Battle Course 1" );		}break;
		case kRomTrackBattleCourse2 :		{ return( @"Battle Course 2" );		}break;
		
		default :							{ return( @"Unknown" );				}		
	}
}

static inline NSString *RomKartToString( kRomKart kart )
{
	switch( kart )
	{
		case kRomKartMario :				{ return( @"Mario" );				}break;
		case kRomKartBowser :				{ return( @"Bowser" );				}break;
		case kRomKartPrincess :				{ return( @"Princess" );			}break;
		case kRomKartKong :					{ return( @"Kong" );				}break;
		case kRomKartYoshi :				{ return( @"Yoshi" );				}break;
		case kRomKartLuigi :				{ return( @"Luigi" );				}break;
		case kRomKartKoopa :				{ return( @"Koopa" );				}break;
		case kRomKartToad :					{ return( @"Toad" );				}break;
		
		default :							{ return( @"Unknown" );				}
	}
}

#endif // _ROMTYPES_H_
