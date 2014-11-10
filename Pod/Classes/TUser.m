//
//  TUser.m
//  TwitchAPI
//
//  Created by PolyNerd on 27/03/14.
//  Copyright (c) 2014 PolyMountain. All rights reserved.
//

#import "TUser.h"
#import "TDictionary.h"

@interface TUser()

//
@property (nonatomic, strong, readwrite) NSString *bio;
@property (nonatomic, strong, readwrite) NSString *name;
@property (nonatomic, strong, readwrite) NSString *type;
@property (nonatomic, strong, readwrite) NSString *display_name;

//
@property (nonatomic, strong, readwrite) NSURL *avatar_URL;

@end

@implementation TUser

- (id)initWithDictionary:dictionary
{
    if((self = [super initWithDictionary:dictionary])) {
        self.bio          = [dictionary stringSafelyFromKey:@"bio"];
        self.name         = [dictionary stringSafelyFromKey:@"name"];
        self.type         = [dictionary stringSafelyFromKey:@"type"];
        self.display_name = [dictionary stringSafelyFromKey:@"display_name"];
        
        self.avatar_URL = [dictionary URLSafelyFromKey:@"logo"];
    }
    
    return self;
}

@end
