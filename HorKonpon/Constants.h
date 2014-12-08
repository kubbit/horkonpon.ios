//
//  Constants.h
//  HorKonpon
//
//  Copyright (c) 2014 Kubbit Information Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "revision.h"

@interface Constants : NSObject

extern NSString* const HORKONPON_API_URL;
extern NSString* const HORKONPON_API_KEY;
extern NSInteger const HORKONPON_API_MESSAGE_VERSION;
extern NSInteger const MIN_GPS_ACCURACY;
extern NSInteger const MAX_GPS_ATTEMPTS;
extern NSInteger const MIN_LOCATION_REFRESH_TIME;

#ifdef DEBUG
	#define DebugLog(s, ...) NSLog(@"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__])
#else
	#define DebugLog(s, ...)
#endif

@end
