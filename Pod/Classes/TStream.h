//
//  TStream.h
//  Objective-Twitch
//
//  Created by Anil Anar on 11.11.2014.
//  Copyright (c) 2014 Anıl Anar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TChannel.h"

@interface TStream : TObject

@property (nonatomic, strong, readonly) NSString *broadcaster;

@property (nonatomic, strong, readonly) NSString *preview;

@property (nonatomic, readonly) NSUInteger viewers;

@property (nonatomic, strong, readonly) TChannel* channel;

@end
