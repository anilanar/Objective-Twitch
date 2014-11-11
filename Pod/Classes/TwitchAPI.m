//
//  TwitchAPI.m
//  TwitchAPI
//
//  Created by PolyNerd on 27/03/14.
//  Copyright (c) 2014 PolyMountain. All rights reserved.
//

#import "MNetwork.h"

#import "TwitchAPI.h"
#import "TMethods.h"

@interface TwitchAPI()

//
@property (nonatomic, strong, readwrite) NSArray *follower;
@property (nonatomic, strong, readwrite) NSArray *subscriber;
@property (nonatomic, strong, readwrite) NSString *user;

@end

@implementation TwitchAPI

//
+ (void)requestFollowersWithName:(NSString *)name
                runOnMainThread:(BOOL)runOnMainThread
                      withBlock:(void (^)(NSArray *followers))block
{
    NSString *url = [NSString stringWithFormat:@"https://api.twitch.tv/kraken/channels/%@/follows", name];
        
    [TMethods requestUsersWithURL:[NSURL URLWithString:url]
                  runOnMainThread:runOnMainThread
                        withBlock:block];
}

+ (void)requestFollowingChannelsWithUsername:(NSString *)username
                runOnMainThread:(BOOL)runOnMainThread
                    withBlock:(void (^)(NSArray *channels))block
{
  NSString *URL = [NSString stringWithFormat:@"https://api.twitch.tv/kraken/users/%@/follows/channels", username];
  [[MNetworkJSONRequest JSONRequest:[TwitchAPI URLRequestWithString:URL]
                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *json)
    {
        NSArray *channelItems = [json objectForKey:@"follows"];
        NSMutableArray *channels = [[NSMutableArray alloc] init];
        for(int i = 0; i < channelItems.count; ++i) {
            [channels addObject: [[TChannel alloc] initWithDictionary:[channelItems[i] objectForKey:@"channel"]]];
        }
        
        [TwitchAPI runBlock:^{
            block(channels);
        } onMainThread:runOnMainThread];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [TwitchAPI runBlock:^{
            block(nil);
        } onMainThread:runOnMainThread];
    }] start];
}

+ (void)requestUserWithAccessToken:(NSString *)accessToken
                   runOnMainThread:(BOOL)runOnMainThread
                         withBlock:(void (^)(TUser *user))block
{
    NSString *URL = @"https://api.twitch.tv/kraken/user";
    NSURLRequest *req = [TwitchAPI URLRequestWithString:URL withAccessToken:accessToken];
    [MNetworkJSONRequest JSONRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        TUser *user = [[TUser alloc] initWithDictionary:JSON];
        [TwitchAPI runBlock:^{
            block(user);
        } onMainThread:runOnMainThread];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [TwitchAPI runBlock:^{
            block(nil);
        } onMainThread:runOnMainThread];
    }];
}

+ (void)requestOnlineFollowingChannelsOfUserWithAccessToken:(NSString *)accessToken
                                          runOnMainThread:(BOOL)runOnMainThread
                                                withBlock:(void (^)(NSArray *channels))block
{
    NSString *URL = @"https://api.twitch.tv/kraken/streams/followed";
    NSURLRequest *req = [TwitchAPI URLRequestWithString:URL withAccessToken:accessToken];
    [[MNetworkJSONRequest JSONRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSArray *streams = [JSON objectForKey:@"streams"];
        NSMutableArray *channels = [[NSMutableArray alloc] init];
        for(int i = 0; i < streams.count; ++i) {
            TChannel *channel = [[TChannel alloc] initWithDictionary:[streams[i] objectForKey:@"channel"]];
            [channels addObject:channel];
        }
        
        [TwitchAPI runBlock:^{
            block(channels);
        } onMainThread:runOnMainThread];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [TwitchAPI runBlock:^{
            block(nil);
        } onMainThread:runOnMainThread];
    }] start];
}


//
+ (void)requestUserWithName:(NSString *)name
            runOnMainThread:(BOOL)runOnMainThread
                  withBlock:(void (^)(TUser *user))block
{
    NSString *URL = [NSString stringWithFormat:@"https://api.twitch.tv/kraken/users/%@", name];
    
    [[MNetworkJSONRequest JSONRequest:[TwitchAPI URLRequestWithString:URL]
                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *json)
      {
          TUser *user = nil;
          
          if(![[json objectForKey:@"message"] count]) {
              user = [[TUser alloc] initWithDictionary:json];
          }
          
          [TwitchAPI runBlock:^{
              block(user);
          } onMainThread:runOnMainThread];
      } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
          [TwitchAPI runBlock:^{
              block(nil);
          } onMainThread:runOnMainThread];
      }] start];
}

//
+ (void)requestTeamWithName:(NSString *)name
            runOnMainThread:(BOOL)runOnMainThread
                  withBlock:(void (^)(TTeam *user))block
{
    NSString *URL = [NSString stringWithFormat:@"https://api.twitch.tv/kraken/teams/%@", name];
    
    [[MNetworkJSONRequest JSONRequest:[TwitchAPI URLRequestWithString:URL]
                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *json)
      {
        TTeam *team = nil;
          
          if(![[json objectForKey:@"message"] isEqualToString:@"Not found"]) {
              team = [[TTeam alloc] initWithDictionary:json];
          }
          
          [TwitchAPI runBlock:^{
              block(team);
          } onMainThread:runOnMainThread];
          
      } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
          [TwitchAPI runBlock:^{
              block(nil);
          } onMainThread:runOnMainThread];
      }] start];
}

//
+ (void)requestChannelWithName:(NSString *)name
               runOnMainThread:(BOOL)runOnMainThread
                     withBlock:(void (^)(TChannel *channel))block
{
    NSString *URL = [NSString stringWithFormat:@"https://api.twitch.tv/kraken/channels/%@", name];
    
    [[MNetworkJSONRequest JSONRequest:[TwitchAPI URLRequestWithString:URL]
                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *json)
      {
          TChannel *channel = nil;
          
          if(![[json objectForKey:@"message"] isEqualToString:@"Not found"]) {
              channel = [[TChannel alloc] initWithDictionary:json];
          }
          
          [TwitchAPI runBlock:^{
              block(channel);
          } onMainThread:runOnMainThread];
      } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
          [TwitchAPI runBlock:^{
              block(nil);
          } onMainThread:runOnMainThread];
      }] start];
}

+ (void)runBlock:(void(^)())block onMainThread:(BOOL) runOnMainThread {
    if(runOnMainThread) {
        dispatch_async(dispatch_get_main_queue(), ^{
            block();
        });
    } else {
        block();
    }
}

+ (NSURLRequest *)URLRequestWithString:(NSString *)string {
    return [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:string]];
}

+ (NSURLRequest *)URLRequestWithString:(NSString *)string withAccessToken:(NSString *)accessToken {
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:string]];
    [req setValue:[NSString stringWithFormat:@"OAuth %@", accessToken] forHTTPHeaderField:@"Authorization"];
    return req;
}

@end
