//
//  TMethods.h
//  TwitchAPI
//
//  Created by PolyNerd on 27/03/14.
//  Copyright (c) 2014 PolyMountain. All rights reserved.
//

#import "TObject.h"

@class TUser;

@interface TMethods : NSObject

/*
 *
 *
 */
+ (void)requestUsersWithURL:(NSURL *)url
               runOnMainThread:(BOOL)runOnMainThread
                     withBlock:(void (^)(NSArray *users))block;

@end