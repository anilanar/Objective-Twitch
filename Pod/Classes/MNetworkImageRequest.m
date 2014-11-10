//
//  MNetworkImageRequest.m
//  MountainCore
//
//  Created by PolyNerd on 22/03/14.
//  Copyright (c) 2014 PolyMountain. All rights reserved.
//

#import "MNetworkImageRequest.h"

static dispatch_queue_t image_request_operation_processing_queue() {
    static dispatch_queue_t M_image_request_operation_processing_queue;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        M_image_request_operation_processing_queue = dispatch_queue_create("com.alamofire.networking.image-request.processing", DISPATCH_QUEUE_CONCURRENT);
    });

    return M_image_request_operation_processing_queue;
}

@interface MNetworkImageRequest ()

@property (readwrite, nonatomic, strong) NSImage *responseImage;

@end

@implementation MNetworkImageRequest

@synthesize responseImage = _responseImage;

+ (instancetype)imageRequest:(NSURLRequest *)urlRequest
										 success:(void (^)(NSImage *image))success
{
    return [self imageRequest:urlRequest imageProcessingBlock:nil success:^(NSURLRequest __unused *request, NSHTTPURLResponse __unused *response, NSImage *image) {
        if (success) {
            success(image);
        }
    } failure:nil];
}

+ (instancetype)imageRequest:(NSURLRequest *)urlRequest
							imageProcessingBlock:(NSImage *(^)(NSImage *))imageProcessingBlock
										 success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSImage *image))success
										 failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure
{
    MNetworkImageRequest *requestOperation = [(MNetworkImageRequest *)[self alloc] initWithRequest:urlRequest];
    [requestOperation setCompletionBlockWithSuccess:^(MNetworkHTTPRequest *operation, id responseObject) {
        if (success) {
            NSImage *image = responseObject;
            if (imageProcessingBlock) {
                dispatch_async(image_request_operation_processing_queue(), ^(void) {
                    NSImage *processedImage = imageProcessingBlock(image);

                    dispatch_async(operation.successCallbackQueue ?: dispatch_get_main_queue(), ^(void) {
                        success(operation.request, operation.response, processedImage);
                    });
                });
            } else {
                success(operation.request, operation.response, image);
            }
        }
    } failure:^(MNetworkHTTPRequest *operation, NSError *error) {
        if (failure) {
            failure(operation.request, operation.response, error);
        }
    }];

    return requestOperation;
}

- (id)initWithRequest:(NSURLRequest *)urlRequest {
    self = [super initWithRequest:urlRequest];
    
    if (!self) {
        return nil;
    }

    return self;
}

- (NSImage *)responseImage {
    if (!_responseImage && [self.responseData length] > 0 && [self isFinished]) {
        NSBitmapImageRep *bitimage = [[NSBitmapImageRep alloc] initWithData:self.responseData];
        self.responseImage = [[NSImage alloc] initWithSize:NSMakeSize([bitimage pixelsWide], [bitimage pixelsHigh])];
        [self.responseImage addRepresentation:bitimage];
    }

    return _responseImage;
}

#pragma mark - MNetworkHTTPRequest

+ (NSSet *)acceptableContentTypes {
    return [NSSet setWithObjects:@"image/tiff", @"image/jpeg", @"image/gif", @"image/png", @"image/ico", @"image/x-icon", @"image/bmp", @"image/x-bmp", @"image/x-xbitmap", @"image/x-win-bitmap", nil];
}

+ (BOOL)canProcessRequest:(NSURLRequest *)request {
    static NSSet * _acceptablePathExtension = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _acceptablePathExtension = [[NSSet alloc] initWithObjects:@"tif", @"tiff", @"jpg", @"jpeg", @"gif", @"png", @"ico", @"bmp", @"cur", nil];
    });

    return [_acceptablePathExtension containsObject:[[request URL] pathExtension]] || [super canProcessRequest:request];
}

- (void)setCompletionBlockWithSuccess:(void (^)(MNetworkHTTPRequest *operation, id responseObject))success
                              failure:(void (^)(MNetworkHTTPRequest *operation, NSError *error))failure
{
    __block MNetworkImageRequest* this = self;
    self.completionBlock = ^ {
        dispatch_async(image_request_operation_processing_queue(), ^(void) {
            if (this.error) {
                if (failure) {
                    dispatch_async(this.failureCallbackQueue ?: dispatch_get_main_queue(), ^{
                        failure(this, this.error);
                    });
                }
            } else {
                if (success) {
                    NSImage *image = nil;

                    image = this.responseImage;

                    dispatch_async(this.successCallbackQueue ?: dispatch_get_main_queue(), ^{
                        success(this, image);
                    });
                }
            }
        });
    };
}

@end
