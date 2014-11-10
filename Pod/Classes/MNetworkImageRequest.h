//
//  MNetworkImageRequest.h
//  MountainCore
//
//  Created by PolyNerd on 22/03/14.
//  Copyright (c) 2014 PolyMountain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Availability.h>
#import <Cocoa/Cocoa.h>

#import "MNetworkHTTPRequest.h"

@interface MNetworkImageRequest : MNetworkHTTPRequest

/*
 *
 *
 */
@property (readonly, nonatomic, strong) NSImage *responseImage;

/*
 *
 *
 */
+ (instancetype)imageRequest:(NSURLRequest *)urlRequest
										 success:(void (^)(NSImage *image))success;

/*
 *
 *
 */
+ (instancetype)imageRequest:(NSURLRequest *)urlRequest
							imageProcessingBlock:(NSImage *(^)(NSImage *image))imageProcessingBlock
										 success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSImage *image))success
										 failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure;

@end
