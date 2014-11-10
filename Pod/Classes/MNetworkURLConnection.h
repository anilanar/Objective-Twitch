//
//  MNetworkURLConnection.h
//  MountainCore
//
//  Created by PolyNerd on 22/03/14.
//  Copyright (c) 2014 PolyMountain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Availability.h>

typedef enum {
    MSSLPinningModeNone,
    MSSLPinningModePublicKey,
    MSSLPinningModeCertificate,
} MNetworkURLConnectionSSLPinningMode;

@interface MNetworkURLConnection : NSOperation <NSURLConnectionDelegate, NSURLConnectionDataDelegate, NSCoding, NSCopying>

/*
 *
 *
 */
@property (nonatomic, strong) NSSet *runLoopModes;

/*
 *
 *
 */
@property (readonly, nonatomic, strong) NSURLRequest *request;

/*
 *
 *
 */
@property (readonly, nonatomic, strong) NSURLResponse *response;

/*
 *
 *
 */
@property (readonly, nonatomic, strong) NSError *error;



/*
 *
 *
 */
@property (readonly, nonatomic, strong) NSData *responseData;

/*
 *
 *
 */
@property (readonly, nonatomic, copy) NSString *responseString;

/*
 *
 *
 */
@property (readonly, nonatomic, assign) NSStringEncoding responseStringEncoding;



/*
 *
 *
 */
@property (nonatomic, assign) BOOL shouldUseCredentialStorage;

/*
 *
 *
 */
@property (nonatomic, strong) NSURLCredential *credential;

/*
 *
 *
 */
@property (nonatomic, assign) MNetworkURLConnectionSSLPinningMode SSLPinningMode;



/*
 *
 *
 */
@property (nonatomic, strong) NSInputStream *inputStream;

/*
 *
 *
 */
@property (nonatomic, strong) NSOutputStream *outputStream;



/*
 *
 *
 */
@property (nonatomic, strong) NSDictionary *userInfo;



/*
 *
 *
 */
- (id)initWithRequest:(NSURLRequest *)urlRequest;



/*
 *
 *
 */
- (void)pause;

/*
 *
 *
 */
- (BOOL)isPaused;

/*
 *
 *
 */
- (void)resume;



/*
 *
 *
 */
- (void)setUploadProgressBlock:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))block;

/*
 *
 *
 */
- (void)setDownloadProgressBlock:(void (^)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead))block;



/*
 *
 *
 */
- (void)setWillSendRequestForAuthenticationChallengeBlock:(void (^)(NSURLConnection *connection, NSURLAuthenticationChallenge *challenge))block;

/*
 *
 *
 */
- (void)setRedirectResponseBlock:(NSURLRequest * (^)(NSURLConnection *connection, NSURLRequest *request, NSURLResponse *redirectResponse))block;

/*
 *
 *
 */
- (void)setCacheResponseBlock:(NSCachedURLResponse * (^)(NSURLConnection *connection, NSCachedURLResponse *cachedResponse))block;

@end



/*
 *
 *
 */
extern NSString * const MNetworkErrorDomain;
extern NSString * const MNetworkOperationFailingURLRequestErrorKey;
extern NSString * const MNetworkOperationFailingURLResponseErrorKey;



/*
 *
 *
 */
extern NSString * const MNetworkOperationDidStartNotification;

/*
 *
 *
 */
extern NSString * const MNetworkOperationDidFinishNotification;
