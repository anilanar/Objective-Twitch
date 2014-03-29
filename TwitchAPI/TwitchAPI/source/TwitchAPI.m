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



//
+ (void)requestUserWithName:(NSString *)name
            runOnMainThread:(BOOL)runOnMainThread
                  withBlock:(void (^)(TUser *user))block
{
    NSString *url = [NSString stringWithFormat:@"https://api.twitch.tv/kraken/users/%@", name];
    
    [[MNetworkJSONRequest JSONRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]
                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *json)
      {
          TUser *user = nil;
          
          if(![[json objectForKey:@"message"] isEqualToString:@"Not found"]) {
              user = [[TUser alloc] initWithDictionary:json];
          }
          
          if(runOnMainThread) {
              dispatch_async(dispatch_get_main_queue(), ^{
                  block(user);
              });
          } else {
              block(user);
          }
      } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
          if(runOnMainThread) {
              dispatch_async(dispatch_get_main_queue(), ^{
                  block(nil);
              });
          } else {
              block(nil);
          }
      }] start];
}

//
+ (void)requestTeamWithName:(NSString *)name
            runOnMainThread:(BOOL)runOnMainThread
                  withBlock:(void (^)(TTeam *user))block
{
    NSString *url = [NSString stringWithFormat:@"https://api.twitch.tv/kraken/teams/%@", name];
    
    [[MNetworkJSONRequest JSONRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]
                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *json)
      {
          TTeam *team = nil;
          
          if(![[json objectForKey:@"message"] isEqualToString:@"Not found"]) {
              team = [[TTeam alloc] initWithDictionary:json];
          }
          
          if(runOnMainThread) {
              dispatch_async(dispatch_get_main_queue(), ^{
                  block(team);
              });
          } else {
              block(team);
          }
      } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
          if(runOnMainThread) {
              dispatch_async(dispatch_get_main_queue(), ^{
                  block(nil);
              });
          } else {
              block(nil);
          }
      }] start];
}

//
+ (void)requestChannelWithName:(NSString *)name
               runOnMainThread:(BOOL)runOnMainThread
                     withBlock:(void (^)(TChannel *channel))block
{
    NSString *url = [NSString stringWithFormat:@"https://api.twitch.tv/kraken/channels/%@", name];
    
    [[MNetworkJSONRequest JSONRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]
                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *json)
      {
          TChannel *channel = nil;
          
          if(![[json objectForKey:@"message"] isEqualToString:@"Not found"]) {
              channel = [[TChannel alloc] initWithDictionary:json];
          }
          
          if(runOnMainThread) {
              dispatch_async(dispatch_get_main_queue(), ^{
                  block(channel);
              });
          } else {
              block(channel);
          }
      } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
          if(runOnMainThread) {
              dispatch_async(dispatch_get_main_queue(), ^{
                  block(nil);
              });
          } else {
              block(nil);
          }
      }] start];
}

@end
