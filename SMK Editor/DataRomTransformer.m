//
//  DataRomTransformer.m
//  SMK Editor
//
//  Created by Ian Sidor on 28/01/2012.
//  Copyright (c) 2012 Banana Iguana. All rights reserved.
//

#import "DataRomTransformer.h"
#import "DataRom.h"

@implementation DataRomIconTransformer

+(Class)transformedValueClass
{
    return( [DataRom class] );
}

+(BOOL)allowsReverseTransformation
{
    return( NO );
}

-(id)transformedValue:(id)value
{
    if( value == nil )
		return nil;

    if( [value isKindOfClass:[DataRom class]] )
	{
		DataRom *rom = (DataRom*)value;
		
		return( rom.icon );        
    }
	
    return( nil );
}

@end

@implementation DataRomNameTransformer

+(Class)transformedValueClass
{
    return( [DataRom class] );
}

+(BOOL)allowsReverseTransformation
{
    return( NO );
}

-(id)transformedValue:(id)value
{
    if( value == nil )
		return nil;

    if( [value isKindOfClass:[DataRom class]] )
	{
		DataRom *rom = (DataRom*)value;
		
		return( rom.name );        
    }
	
    return( nil );
}

@end
