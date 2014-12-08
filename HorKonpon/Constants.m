//
//  Constants.m
//  HorKonpon
//
//  Copyright (c) 2014 Kubbit Information Technology. All rights reserved.
//

#import "Constants.h"

@implementation Constants

NSString* const HORKONPON_API_URL = @"https://horkonpon.kubbit.com/api";
// Contact Kubbit (horkonpon@kubbit.com) to get your API key
// (free for non-comercial use). This key is to prevent the API from
// becoming an open relay for spammers.
#warning API key needed. Contact Kubbit at horkonpon@kubbit.com to get it.
NSString* const HORKONPON_API_KEY = @"";
NSInteger const HORKONPON_API_MESSAGE_VERSION = 2;
NSInteger const MIN_GPS_ACCURACY = 50;
NSInteger const MAX_GPS_ATTEMPTS = 5;
NSInteger const MIN_LOCATION_REFRESH_TIME = 30;

@end
