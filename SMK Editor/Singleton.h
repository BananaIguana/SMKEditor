//
//  Singleton.h
//  SMK Editor
//
//  Created by Ian Sidor
//  Copyright 2012 Banana Iguan. All rights reserved.
//

/*!
 *
 * SINGLETON_IMPLEMENTATION
 *
 * Use these macros to add the default singleton functions to your file, there is
 * no need to replace or override any of the defined singleton functions & if you
 * need to, don't use these macros. Use your 'init' & 'dealloc' methods as normal.
 * 
 * Define your header as a normal class implementation, but add SINGLETON_INSTANCE(); to the
 * methods list
 *
 *----------------------------------------------------------------------------------------
 * sourceExample.m
 * ----------------------------------------------------------------------------------------
 * 
 * #include <Foundation/Foundation.h>
 * 
 * @implementation MySingleton
 * 
 * SINGLETON_IMPLEMENTATION( MySingleton );				// Add macro here
 * 
 * // initialise as normal & add other functions
 * 
 * -(id)init
 * {
 *              self = [super init];
 * 
 *              if( self );
 *              {
 *                      // do some initialisation
 *
 *              }
 *
 *              return( self );
 * }
 *
 * @end
 *
 * ----------------------------------------------------------------------------------------
 * headerExample.h
 * ----------------------------------------------------------------------------------------
 *
 * @interface MySingleton : NSObject
 * {
 *              NSString *myObject;
 * }
 *
 * -(void)myFunction;
 *
 * SINGLETON_INTERFACE();								// Add this here
 *
 * @end
 *
 * ----------------------------------------------------------------------------------------
 *
 */     

#define SINGLETON_IMPLEMENTATION( classname )\
static classname *shared##classname = nil;\
+(classname*)sharedInstance\
{\
        @synchronized( self )\
        {\
                if( shared##classname == nil )\
                {\
                        shared##classname = [[super allocWithZone:NULL] init];\
                }\
        }\
\
        return( shared##classname );\
}\
\
+(id)allocWithZone:(NSZone*)zone\
{\
        return( [self sharedInstance] );\
}\
\
-(id)copyWithZone:(NSZone*)zone\
{\
        return( self );\
}

#define SINGLETON_INTERFACE( classname )                        +(classname*)sharedInstance
