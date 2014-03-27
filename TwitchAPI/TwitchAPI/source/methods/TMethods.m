//
//  TMethods.m
//  TwitchAPI
//
//  Created by PolyNerd on 27/03/14.
//  Copyright (c) 2014 PolyMountain. All rights reserved.
//

#import "MNetwork.h"

#import "TMethods.h"
#import "TUser.h"

@implementation TMethods

//
+ (void)requestUsersWithURL:(NSURL *)url
            runOnMainThread:(BOOL)runOnMainThread
                  withBlock:(void (^)(NSArray *users))block
{
    [[MNetworkJSONRequest JSONRequest:[NSURLRequest requestWithURL:url]
                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *json)
      {
          NSArray *users = [json objectForKey:@"follows"];
          NSMutableArray *musers = [[NSMutableArray alloc] initWithCapacity:[users count]];
          
          for(NSDictionary *userData in users) {
              @autoreleasepool {
                  TUser *user = [[TUser alloc] initWithDictionary:[userData objectForKey:@"user"]];
                  [musers addObject:user];
              }
          }
          
          if([musers count] == 0) {
              musers = nil;
          }
          
          if(runOnMainThread) {
              dispatch_async(dispatch_get_main_queue(), ^{
                  block(musers);
              });
          } else {
              block(musers);
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