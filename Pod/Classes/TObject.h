//
//  TObject.h
//  TwitchAPI
//
//  Created by PolyNerd on 27/03/14.
//  Copyright (c) 2014 PolyMountain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TObject : NSObject

/*
 *
 *
 */
@property (nonatomic, readonly) NSUInteger identifier;



/*
 *
 *
 */
- (id)initWithDictionary:dictionary;

@end
