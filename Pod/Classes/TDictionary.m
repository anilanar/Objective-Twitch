//
//  TDictionary.m
//  TwitchAPI
//
//  Created by PolyNerd on 27/03/14.
//  Copyright (c) 2014 PolyMountain. All rights reserved.
//

#import "TDictionary.h"

@implementation NSDictionary(TwitchAPI)

- (id)objectSafelyFromKey:(id)key
{
    if([self objectForKey:key] == [NSNull null] || [self objectForKey:key] == nil) {
        return nil;
    }
    
    return [self objectForKey:key];
}

- (BOOL)boolSafelyFromKey:(id)key
{
    if([self objectForKey:key] == [NSNull null] || [self objectForKey:key] == FALSE) {
        return NO;
    }
    
    return YES;
}

- (NSURL *)URLSafelyFromKey:(id)key
{
    if([self objectForKey:key] == [NSNull null] || [self objectForKey:key] == nil) {
        return nil;
    }
    
    NSString *urlString = [[self objectForKey:key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return [NSURL URLWithString:urlString];
}

- (NSUInteger)uintSafelyFromKey:(id)key
{
    if([self objectForKey:key] == [NSNull null] || [self objectForKey:key] == nil) {
        return NSNotFound;
    }
    
    return [[self objectForKey:key] integerValue];
}

- (NSString *)stringSafelyFromKey:(id)key
{
    if([self objectForKey:key] == [NSNull null] || [self objectForKey:key] == nil) {
        return nil;
    }
    
    return [NSString stringWithString:[self objectForKey:key]];
}

@end
