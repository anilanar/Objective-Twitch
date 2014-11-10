//
//  MNetworkJSONRequest.m
//  MountainCore
//
//  Created by PolyNerd on 22/03/14.
//  Copyright (c) 2014 PolyMountain. All rights reserved.
//

#import "MNetworkJSONRequest.h"

static dispatch_queue_t json_request_operation_processing_queue() {
    static dispatch_queue_t M_json_request_operation_processing_queue;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        M_json_request_operation_processing_queue = dispatch_queue_create("com.alamofire.networking.json-request.processing", DISPATCH_QUEUE_CONCURRENT);
    });

    return M_json_request_operation_processing_queue;
}

@interface MNetworkJSONRequest ()

@property (readwrite, nonatomic, strong) id responseJSON;
@property (readwrite, nonatomic, strong) NSError *JSONError;
@property (readwrite, nonatomic, strong) NSRecursiveLock *lock;

@end

@implementation MNetworkJSONRequest

@synthesize JSONError = _JSONError;
@synthesize responseJSON = _responseJSON;
@synthesize JSONReadingOptions = _JSONReadingOptions;
@dynamic lock;

+ (instancetype)JSONRequest:(NSURLRequest *)urlRequest
										success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON))success
										failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure
{
    MNetworkJSONRequest *requestOperation = [(MNetworkJSONRequest *)[self alloc] initWithRequest:urlRequest];
    [requestOperation setCompletionBlockWithSuccess:^(MNetworkHTTPRequest *operation, id responseObject) {
        if (success) {
            success(operation.request, operation.response, responseObject);
        }
    } failure:^(MNetworkHTTPRequest *operation, NSError *error) {
        if (failure) {
            failure(operation.request, operation.response, error, [(MNetworkJSONRequest *)operation responseJSON]);
        }
    }];

    return requestOperation;
}


- (id)responseJSON {
    [self.lock lock];
    
    if (!_responseJSON && [self.responseData length] > 0 && [self isFinished] && !self.JSONError) {
        NSError *error = nil;

        if (self.responseString && ![self.responseString isEqualToString:@" "]) {
            NSData *data = [self.responseString dataUsingEncoding:NSUTF8StringEncoding];

            if (data) {
                self.responseJSON = [NSJSONSerialization JSONObjectWithData:data options:self.JSONReadingOptions error:&error];
            } else {
                NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                [userInfo setValue:@"Operation responseData failed decoding as a UTF-8 string" forKey:NSLocalizedDescriptionKey];
                [userInfo setValue:[NSString stringWithFormat:@"Could not decode string: %@", self.responseString] forKey:NSLocalizedFailureReasonErrorKey];
                error = [[NSError alloc] initWithDomain:MNetworkErrorDomain code:NSURLErrorCannotDecodeContentData userInfo:userInfo];
            }
        }

        self.JSONError = error;
    }
    
    [self.lock unlock];

    return _responseJSON;
}

- (NSError *)error {
    if (_JSONError) {
        return _JSONError;
    } else {
        return [super error];
    }
}

#pragma mark - MNetworkHTTPRequest

+ (NSSet *)acceptableContentTypes {
    return [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", nil];
}

+ (BOOL)canProcessRequest:(NSURLRequest *)request {
    return [[[request URL] pathExtension] isEqualToString:@"json"] || [super canProcessRequest:request];
}

- (void)setCompletionBlockWithSuccess:(void (^)(MNetworkHTTPRequest *operation, id responseObject))success
                              failure:(void (^)(MNetworkHTTPRequest *operation, NSError *error))failure
{   
    __block MNetworkJSONRequest *this = self;
    this.completionBlock = ^ {
        if (this.error) {
            if (failure) {
                dispatch_async(this.failureCallbackQueue ?: dispatch_get_main_queue(), ^{
                    failure(this, this.error);
                });
            }
        } else {
            dispatch_async(json_request_operation_processing_queue(), ^{
                id JSON = this.responseJSON;

                if (this.error) {
                    if (failure) {
                        dispatch_async(this.failureCallbackQueue ?: dispatch_get_main_queue(), ^{
                            failure(this, this.error);
                        });
                    }
                } else {
                    if (success) {
                        dispatch_async(this.successCallbackQueue ?: dispatch_get_main_queue(), ^{
                            success(this, JSON);
                        });
                    }
                }
            });
        }
    };
}

@end
