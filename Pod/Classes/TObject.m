//
//  TObject.m
//  TwitchAPI
//
//  Created by PolyNerd on 27/03/14.
//  Copyright (c) 2014 PolyMountain. All rights reserved.
//

#import "TObject.h"
#import "TDictionary.h"

@interface TObject()

@property (nonatomic, readwrite) NSUInteger identifier;

@end

@implementation TObject

- (id)initWithDictionary:dictionary
{
    if(self = [super init]) {
        self.identifier = [dictionary uintSafelyFromKey:@"id"];
    }
    
    return self;
}

- (BOOL)isEqual:(id)object
{
    if([object isKindOfClass:[self class]]) {
        return (self.identifier == [(TObject *)object identifier]);
    }
    
    return NO;
}

@end
