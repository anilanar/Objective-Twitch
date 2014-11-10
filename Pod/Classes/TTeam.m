//
//  TTeam.m
//  TwitchAPI
//
//  Created by PolyNerd on 27/03/14.
//  Copyright (c) 2014 PolyMountain. All rights reserved.
//

#import "TTeam.h"
#import "TDictionary.h"

@interface TTeam()

//
@property (nonatomic, strong, readwrite) NSString *name;
@property (nonatomic, strong, readwrite) NSString *info;
@property (nonatomic, strong, readwrite) NSString *display_name;

//
@property (nonatomic, strong, readwrite) NSURL *avatar_URL;
@property (nonatomic, strong, readwrite) NSURL *banner_URL;

@end

@implementation TTeam

- (id)initWithDictionary:dictionary
{
    if((self = [super initWithDictionary:dictionary])) {
        self.name         = [dictionary stringSafelyFromKey:@"name"];
        self.info         = [dictionary stringSafelyFromKey:@"info"];
        self.display_name = [dictionary stringSafelyFromKey:@"display_name"];
        
        self.avatar_URL = [dictionary URLSafelyFromKey:@"logo"];
        self.banner_URL = [dictionary URLSafelyFromKey:@"banner"];
    }
    
    return self;
}

@end
