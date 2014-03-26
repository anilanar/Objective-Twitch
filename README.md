Objective-Twitch
========

Objective-Twitch is an Objective-C framework for OSX that provides an easy to use asynchronous interface to the [Twitch API](https://api.twitch.tv/).

How To
--------

    git clone https://github.com/PolyMountain/Objective-Twitch.git

Example
--------

The following snippet demonstrates how to get the game the user is playing.

``` obj-c
#import <TwitchAPI/TwitchAPI.h>

[TwitchAPI InfoByUsername:@"PolyMountain"
    runOnMainThread:NO
        withBlock:^(NSArray *info){
			NSLog(@"%@ is playing %@", info.display_name, info.game);
		}];
```

Change Log
--------

* **0.0.4** - Initial release with support for the full Twitch api.

License
--------

Copyright (c) 2011 Maurice Meyer

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"),
to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
IN THE SOFTWARE.
