//
//  TChannel.m
//  TwitchAPI
//
//  Created by PolyNerd on 27/03/14.
//  Copyright (c) 2014 PolyMountain. All rights reserved.
//

#import "TChannel.h"
#import "TDictionary.h"

@interface TChannel()

//
@property (nonatomic, strong, readwrite) NSString *name;
@property (nonatomic, strong, readwrite) NSString *game;
@property (nonatomic, strong, readwrite) NSString *status;
@property (nonatomic, strong, readwrite) NSString *display_name;
@property (nonatomic, strong, readwrite) NSString *team_name;
@property (nonatomic, strong, readwrite) NSString *team_display_name;

//
@property (nonatomic, strong, readwrite) NSURL *url;
@property (nonatomic, strong, readwrite) NSURL *avatar_URL;
@property (nonatomic, strong, readwrite) NSURL *banner_URL;
@property (nonatomic, strong, readwrite) NSURL *video_banner_url;
@property (nonatomic, strong, readwrite) NSURL *profile_banner_url;

//
@property (nonatomic, readwrite) NSUInteger *delay;
@property (nonatomic, readwrite) NSUInteger *views;
@property (nonatomic, readwrite) NSUInteger *follower;

//
@property (nonatomic, readwrite) BOOL *mature;
@property (nonatomic, readwrite) BOOL *reported;

@end

@implementation TChannel

- (id)initWithDictionary:dictionary
{
    if((self = [super initWithDictionary:dictionary])) {
        self.name              = [dictionary stringSafelyFromKey:@"name"];
        self.game              = [dictionary stringSafelyFromKey:@"game"];
        self.status            = [dictionary stringSafelyFromKey:@"status"];
        self.display_name      = [dictionary stringSafelyFromKey:@"display_name"];
        self.team_name         = [dictionary stringSafelyFromKey:@"primary_team_name"];
        self.team_display_name = [dictionary stringSafelyFromKey:@"primary_team_display_name"];
        
        self.url                = [dictionary URLSafelyFromKey:@"url"];
        self.avatar_URL         = [dictionary URLSafelyFromKey:@"logo"];
        self.banner_URL         = [dictionary URLSafelyFromKey:@"banner"];
        self.video_banner_url   = [dictionary URLSafelyFromKey:@"video_banner"];
        self.profile_banner_url = [dictionary URLSafelyFromKey:@"profile_banner"];
        
        self.delay    = [dictionary uintSafelyFromKey:@"delay"];
        self.views    = [dictionary uintSafelyFromKey:@"views"];
        self.follower = [dictionary uintSafelyFromKey:@"followers"];
        
        self.mature   = [dictionary boolSafelyFromKey:@"mature"];
        self.reported = [dictionary boolSafelyFromKey:@"abuse_reported"];
    }
    
    return self;
}

@end
