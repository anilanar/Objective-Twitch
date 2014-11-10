//
//  TChannel.h
//  TwitchAPI
//
//  Created by PolyNerd on 27/03/14.
//  Copyright (c) 2014 PolyMountain. All rights reserved.
//

#import "TObject.h"

@interface TChannel : TObject

/*
 *
 *
 */
@property (nonatomic, strong, readonly) NSString *name;

/*
 *
 *
 */
@property (nonatomic, strong, readonly) NSString *game;

/*
 *
 *
 */
@property (nonatomic, strong, readonly) NSString *status;

/*
 *
 *
 */
@property (nonatomic, strong, readonly) NSString *display_name;

/*
 *
 *
 */
@property (nonatomic, strong, readonly) NSString *team_name;

/*
 *
 *
 */
@property (nonatomic, strong, readonly) NSString *team_display_name;



/*
 *
 *
 */
@property (nonatomic, strong, readonly) NSURL *url;

/*
 *
 *
 */
@property (nonatomic, strong, readonly) NSURL *avatar_URL;

/*
 *
 *
 */
@property (nonatomic, strong, readonly) NSURL *banner_URL;

/*
 *
 *
 */
@property (nonatomic, strong, readonly) NSURL *video_banner_url;

/*
 *
 *
 */
@property (nonatomic, strong, readonly) NSURL *profile_banner_url;



/*
 *
 *
 */
@property (nonatomic, readonly) NSUInteger *delay;

/*
 *
 *
 */
@property (nonatomic, readonly) NSUInteger *views;

/*
 *
 *
 */
@property (nonatomic, readonly) NSUInteger *follower;



/*
 *
 *
 */
@property (nonatomic, readonly) BOOL *mature;

/*
 *
 *
 */
@property (nonatomic, readonly) BOOL *reported;

@end
