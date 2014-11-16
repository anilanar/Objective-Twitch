//
//  TStream.m
//  Objective-Twitch
//
//  Created by Anil Anar on 11.11.2014.
//  Copyright (c) 2014 Anıl Anar. All rights reserved.
//

#import "TStream.h"
#import "TDictionary.h"

@implementation TStream

- (instancetype)initWithDictionary:(id)dictionary {
    if(self = [super initWithDictionary:dictionary]) {
        _broadcaster = [dictionary stringSafelyFromKey:@"broadcaster"];
        _viewers = [dictionary uintSafelyFromKey:@"viewers"];
        _channel = [[TChannel alloc] initWithDictionary:[dictionary objectForKey:@"channel"]];
        _preview = [[dictionary objectForKey:@"preview"] stringSafelyFromKey:@"medium"];
        
    }
    return self;
}

@end
