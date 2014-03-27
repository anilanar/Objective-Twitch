//
//  MNetworkJSONRequest.h
//  MountainCore
//
//  Created by PolyNerd on 22/03/14.
//  Copyright (c) 2014 PolyMountain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNetworkHTTPRequest.h"

/*
 *
 *
 */
@interface MNetworkJSONRequest : MNetworkHTTPRequest



/*
 *
 *
 */
@property (readonly, nonatomic, strong) id responseJSON;

/*
 *
 *
 */
@property (nonatomic, assign) NSJSONReadingOptions JSONReadingOptions;
 


/*
 *
 *
 */
+ (instancetype)JSONRequest:(NSURLRequest *)urlRequest
                                        success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON))success
                                        failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure;

@end
