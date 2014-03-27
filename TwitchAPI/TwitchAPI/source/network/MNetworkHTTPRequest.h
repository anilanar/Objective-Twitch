//
//  MNetworkHTTPRequest.h
//  MountainCore
//
//  Created by PolyNerd on 22/03/14.
//  Copyright (c) 2014 PolyMountain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNetworkURLConnection.h"

@interface MNetworkHTTPRequest : MNetworkURLConnection

/*
 *
 *
 */
@property (readonly, nonatomic, strong) NSHTTPURLResponse *response;



/*
 *
 *
 */
@property (nonatomic, readonly) BOOL hasAcceptableStatusCode;

/*
 *
 *
 */
@property (nonatomic, readonly) BOOL hasAcceptableContentType;

/*
 *
 *
 */
@property (nonatomic, assign) dispatch_queue_t successCallbackQueue;

/*
 *
 *
 */
@property (nonatomic, assign) dispatch_queue_t failureCallbackQueue;



/*
 *
 *
 */
+ (NSIndexSet *)acceptableStatusCodes;

/*
 *
 *
 */
+ (NSSet *)acceptableContentTypes;

/*
 *
 *
 */
+ (void)addAcceptableContentTypes:(NSSet *)contentTypes;



/*
 *
 *
 */
+ (BOOL)canProcessRequest:(NSURLRequest *)urlRequest;



/*
 *
 *
 */
- (void)setCompletionBlockWithSuccess:(void (^)(MNetworkHTTPRequest *operation, id responseObject))success
                              failure:(void (^)(MNetworkHTTPRequest *operation, NSError *error))failure;

@end



/*
 *
 *
 */
extern NSSet * MContentTypesFromHTTPHeader(NSString *string);