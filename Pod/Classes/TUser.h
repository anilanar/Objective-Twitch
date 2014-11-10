//
//  TUser.h
//  TwitchAPI
//
//  Created by PolyNerd on 27/03/14.
//  Copyright (c) 2014 PolyMountain. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TObject.h"

@interface TUser : TObject

/*
 *
 *
 */
@property (nonatomic, strong, readonly) NSString *bio;

/*
 *
 *
 */
@property (nonatomic, strong, readonly) NSString *name;

/*
 *
 *
 */
@property (nonatomic, strong, readonly) NSString *type;

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

@end
