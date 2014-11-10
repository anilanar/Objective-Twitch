//
//  TDictionary.h
//  TwitchAPI
//
//  Created by PolyNerd on 27/03/14.
//  Copyright (c) 2014 PolyMountain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary(TwitchAPI)

/*
 *
 *
 */
- (id)objectSafelyFromKey:(id)key;

/*
 *
 *
 */
- (BOOL)boolSafelyFromKey:(id)key;

/*
 *
 *
 */
- (NSURL *)URLSafelyFromKey:(id)key;

/*
 *
 *
 */
- (NSUInteger)uintSafelyFromKey:(id)key;

/*
 *
 *
 */
- (NSString *)stringSafelyFromKey:(id)key;

@end
