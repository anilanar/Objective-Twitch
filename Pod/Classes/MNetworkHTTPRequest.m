//
//  MNetworkHTTPRequest.m
//  MountainCore
//
//  Created by PolyNerd on 22/03/14.
//  Copyright (c) 2014 PolyMountain. All rights reserved.
//

#import "MNetworkHTTPRequest.h"
#import <objc/runtime.h>

NSSet * MContentTypesFromHTTPHeader(NSString *string) {
    if (!string) {
        return nil;
    }

    NSArray *mediaRanges = [string componentsSeparatedByString:@","];
    NSMutableSet *mutableContentTypes = [NSMutableSet setWithCapacity:mediaRanges.count];

    [mediaRanges enumerateObjectsUsingBlock:^(NSString *mediaRange, __unused NSUInteger idx, __unused BOOL *stop) {
        NSRange parametersRange = [mediaRange rangeOfString:@";"];
        if (parametersRange.location != NSNotFound) {
            mediaRange = [mediaRange substringToIndex:parametersRange.location];
        }

        mediaRange = [mediaRange stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

        if (mediaRange.length > 0) {
            [mutableContentTypes addObject:mediaRange];
        }
    }];

    return [NSSet setWithSet:mutableContentTypes];
}

static void MGetMediaTypeAndSubtypeWithString(NSString *string, NSString **type, NSString **subtype) {
    if (!string) {
        return;
    }

    NSScanner *scanner = [NSScanner scannerWithString:string];
    [scanner setCharactersToBeSkipped:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [scanner scanUpToString:@"/" intoString:type];
    [scanner scanString:@"/" intoString:nil];
    [scanner scanUpToString:@";" intoString:subtype];
}

static NSString * MStringFromIndexSet(NSIndexSet *indexSet) {
    NSMutableString *string = [NSMutableString string];

    NSRange range = NSMakeRange([indexSet firstIndex], 1);
    while (range.location != NSNotFound) {
        NSUInteger nextIndex = [indexSet indexGreaterThanIndex:range.location];
        while (nextIndex == range.location + range.length) {
            range.length++;
            nextIndex = [indexSet indexGreaterThanIndex:nextIndex];
        }

        if (string.length) {
            [string appendString:@","];
        }

        if (range.length == 1) {
            [string appendFormat:@"%lu", (long)range.location];
        } else {
            NSUInteger firstIndex = range.location;
            NSUInteger lastIndex = firstIndex + range.length - 1;
            [string appendFormat:@"%lu-%lu", (long)firstIndex, (long)lastIndex];
        }

        range.location = nextIndex;
        range.length = 1;
    }

    return string;
}

static void MSwizzleClassMethodWithClassAndSelectorUsingBlock(Class klass, SEL selector, id block) {
    Method originalMethod = class_getClassMethod(klass, selector);
    IMP implementation = imp_implementationWithBlock((id)block);
    class_replaceMethod(objc_getMetaClass([NSStringFromClass(klass) UTF8String]), selector, implementation, method_getTypeEncoding(originalMethod));
}

#pragma mark -

@interface MNetworkHTTPRequest ()

@property (readwrite, nonatomic, strong) NSURLRequest *request;
@property (readwrite, nonatomic, strong) NSHTTPURLResponse *response;
@property (readwrite, nonatomic, strong) NSError *HTTPError;
@property (readwrite, nonatomic, strong) NSRecursiveLock *lock;

@end

@implementation MNetworkHTTPRequest

@synthesize HTTPError = _HTTPError;
@synthesize successCallbackQueue = _successCallbackQueue;
@synthesize failureCallbackQueue = _failureCallbackQueue;
@dynamic lock;
@dynamic request;
@dynamic response;

- (void)dealloc {
    if (_successCallbackQueue) {
        _successCallbackQueue = NULL;
    }

    if (_failureCallbackQueue) {
        _failureCallbackQueue = NULL;
    }
    
}

- (NSError *)error {
    [self.lock lock];
    
    if (!self.HTTPError && self.response) {
        if (![self hasAcceptableStatusCode] || ![self hasAcceptableContentType]) {
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            [userInfo setValue:self.responseString forKey:NSLocalizedRecoverySuggestionErrorKey];
            [userInfo setValue:[self.request URL] forKey:NSURLErrorFailingURLErrorKey];
            [userInfo setValue:self.request forKey:MNetworkOperationFailingURLRequestErrorKey];
            [userInfo setValue:self.response forKey:MNetworkOperationFailingURLResponseErrorKey];

            if (![self hasAcceptableStatusCode]) {
                NSUInteger statusCode = ([self.response isKindOfClass:[NSHTTPURLResponse class]]) ? (NSUInteger)[self.response statusCode] : 200;
                [userInfo setValue:[NSString stringWithFormat:NSLocalizedStringFromTable(@"Expected status code in (%@), got %d", @"MNetworking", nil), MStringFromIndexSet([[self class] acceptableStatusCodes]), statusCode] forKey:NSLocalizedDescriptionKey];
                self.HTTPError = [[NSError alloc] initWithDomain:MNetworkErrorDomain code:NSURLErrorBadServerResponse userInfo:userInfo];
            } else if (![self hasAcceptableContentType]) {
                // Don't invalidate content type if there is no content
                if ([self.responseData length] > 0) {
                    [userInfo setValue:[NSString stringWithFormat:NSLocalizedStringFromTable(@"Expected content type %@, got %@", @"MNetworking", nil), [[self class] acceptableContentTypes], [self.response MIMEType]] forKey:NSLocalizedDescriptionKey];
                    self.HTTPError = [[NSError alloc] initWithDomain:MNetworkErrorDomain code:NSURLErrorCannotDecodeContentData userInfo:userInfo];
                }
            }
        }
    }
    
    [self.lock unlock];

    if (self.HTTPError) {
        return self.HTTPError;
    } else {
        return [super error];
    }
}

- (NSStringEncoding)responseStringEncoding {
    if (self.response && !self.response.textEncodingName && self.responseData && [self.response respondsToSelector:@selector(allHeaderFields)]) {
        NSString *type = nil;
        MGetMediaTypeAndSubtypeWithString([[self.response allHeaderFields] valueForKey:@"Content-Type"], &type, nil);

        if ([type isEqualToString:@"text"]) {
            return NSISOLatin1StringEncoding;
        }
    }

    return [super responseStringEncoding];
}

- (void)pause {
    unsigned long long offset = 0;
    if ([self.outputStream propertyForKey:NSStreamFileCurrentOffsetKey]) {
        offset = [[self.outputStream propertyForKey:NSStreamFileCurrentOffsetKey] unsignedLongLongValue];
    } else {
        offset = [[self.outputStream propertyForKey:NSStreamDataWrittenToMemoryStreamKey] length];
    }

    NSMutableURLRequest *mutableURLRequest = [self.request mutableCopy];
    if ([self.response respondsToSelector:@selector(allHeaderFields)] && [[self.response allHeaderFields] valueForKey:@"ETag"]) {
        [mutableURLRequest setValue:[[self.response allHeaderFields] valueForKey:@"ETag"] forHTTPHeaderField:@"If-Range"];
    }
    [mutableURLRequest setValue:[NSString stringWithFormat:@"bytes=%llu-", offset] forHTTPHeaderField:@"Range"];
    self.request = mutableURLRequest;

    [super pause];
}

- (BOOL)hasAcceptableStatusCode {
	if (!self.response) {
		return NO;
	}

    NSUInteger statusCode = ([self.response isKindOfClass:[NSHTTPURLResponse class]]) ? (NSUInteger)[self.response statusCode] : 200;
    return ![[self class] acceptableStatusCodes] || [[[self class] acceptableStatusCodes] containsIndex:statusCode];
}

- (BOOL)hasAcceptableContentType {
    if (!self.response) {
		return NO;
	}

    NSString *contentType = [self.response MIMEType];
    if (!contentType) {
        contentType = @"application/octet-stream";
    }

    return ![[self class] acceptableContentTypes] || [[[self class] acceptableContentTypes] containsObject:contentType];
}

- (void)setSuccessCallbackQueue:(dispatch_queue_t)successCallbackQueue {
    if (successCallbackQueue != _successCallbackQueue) {
        if (_successCallbackQueue) {
            _successCallbackQueue = NULL;
        }

        if (successCallbackQueue) {
            _successCallbackQueue = successCallbackQueue;
        }
    }
}

- (void)setFailureCallbackQueue:(dispatch_queue_t)failureCallbackQueue {
    if (failureCallbackQueue != _failureCallbackQueue) {
        if (_failureCallbackQueue) {
            _failureCallbackQueue = NULL;
        }

        if (failureCallbackQueue) {
            _failureCallbackQueue = failureCallbackQueue;
        }
    }
}

- (void)setCompletionBlockWithSuccess:(void (^)(MNetworkHTTPRequest *operation, id responseObject))success
                              failure:(void (^)(MNetworkHTTPRequest *operation, NSError *error))failure
{
    __block MNetworkHTTPRequest *this = self;
    self.completionBlock = ^{
        if (this.error) {
            if (failure) {
                dispatch_async(this.failureCallbackQueue ?: dispatch_get_main_queue(), ^{
                    failure(this, this.error);
                });
            }
        } else {
            if (success) {
                dispatch_async(this.successCallbackQueue ?: dispatch_get_main_queue(), ^{
                    success(this, this.responseData);
                });
            }
        }
    };
}

#pragma mark - MNetworkHTTPRequest

+ (NSIndexSet *)acceptableStatusCodes {
    return [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 100)];
}

+ (void)addAcceptableStatusCodes:(NSIndexSet *)statusCodes {
    NSMutableIndexSet *mutableStatusCodes = [[NSMutableIndexSet alloc] initWithIndexSet:[self acceptableStatusCodes]];
    [mutableStatusCodes addIndexes:statusCodes];
    MSwizzleClassMethodWithClassAndSelectorUsingBlock([self class], @selector(acceptableStatusCodes), ^(__unused id _self) {
        return mutableStatusCodes;
    });
}

+ (NSSet *)acceptableContentTypes {
    return nil;
}

+ (void)addAcceptableContentTypes:(NSSet *)contentTypes {
    NSMutableSet *mutableContentTypes = [[NSMutableSet alloc] initWithSet:[self acceptableContentTypes] copyItems:YES];
    [mutableContentTypes unionSet:contentTypes];
    MSwizzleClassMethodWithClassAndSelectorUsingBlock([self class], @selector(acceptableContentTypes), ^(__unused id _self) {
        return mutableContentTypes;
    });
}

+ (BOOL)canProcessRequest:(NSURLRequest *)request {
    if ([[self class] isEqual:[MNetworkHTTPRequest class]]) {
        return YES;
    }

    return [[self acceptableContentTypes] intersectsSet:MContentTypesFromHTTPHeader([request valueForHTTPHeaderField:@"Accept"])];
}

@end
