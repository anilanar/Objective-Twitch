//
//  TwitchAPI.h
//  TwitchAPI
//
//  Created by PolyNerd on 27/03/14.
//  Copyright (c) 2014 PolyMountain. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TUser.h"
#import "TTeam.h"
#import "TChannel.h"

@interface TwitchAPI : NSObject

/*
 *
 *
 */
@property (nonatomic, strong, readonly) NSArray *follower;

/*
 *
 *
 */
@property (nonatomic, strong, readonly) NSArray *subscriber;

/*
 *
 *
 */
@property (nonatomic, strong, readonly) NSString *user;



/*
 *
 *
 */
+ (void)requestFollowersWithName:(NSString *)name
                 runOnMainThread:(BOOL)runOnMainThread
                       withBlock:(void (^)(NSArray *followers))block;

+ (void)requestFollowingStreamsWithUsername:(NSString *)username
                             runOnMainThread:(BOOL)runOnMainThread
                                   withBlock:(void (^)(NSArray *channels))block;

/*
 *
 *
 */
+ (void)requestUserWithName:(NSString *)name
            runOnMainThread:(BOOL)runOnMainThread
                  withBlock:(void (^)(TUser *user))block;

+ (void)requestOnlineFollowingChannelsOfUserWithAccessToken:(NSString *)accessToken
                                            runOnMainThread:(BOOL)runOnMainThread
                                                  withBlock:(void (^)(NSArray *channels))block;

+ (void)requestUserWithAccessToken:(NSString *)accessToken
                   runOnMainThread:(BOOL)runOnMainThread
                         withBlock:(void (^)(TUser *user))block;

/*
 *
 *
 */
+ (void)requestTeamWithName:(NSString *)name
            runOnMainThread:(BOOL)runOnMainThread
                  withBlock:(void (^)(TTeam *user))block;

/*
 *
 *
 */
+ (void)requestChannelWithName:(NSString *)name
               runOnMainThread:(BOOL)runOnMainThread
                     withBlock:(void (^)(TChannel *user))block;

@end
