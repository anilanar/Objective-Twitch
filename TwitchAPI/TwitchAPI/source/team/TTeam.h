//
//  TTeam.h
//  TwitchAPI
//
//  Created by PolyNerd on 27/03/14.
//  Copyright (c) 2014 PolyMountain. All rights reserved.
//

#import "TObject.h"

@interface TTeam : TObject

/*
 *
 *
 */
@property (nonatomic, strong, readonly) NSString *name;

/*
 *
 *
 */
@property (nonatomic, strong, readonly) NSString *info;

/*
 *
 *
 */
@property (nonatomic, strong, readonly) NSString *display_name;



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

@end
