//
//  HttpPost.h
//  HorKonpon
//
//  Copyright (c) 2014 Kubbit Information Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface HttpPost : NSObject

extern float const TIMEOUT;

@property (nonatomic, retain) NSMutableData* responseData;
@property (nonatomic, assign) id delegate;

+ (NSString*) urlEncode:(NSString*)pData;
- (void) send:(NSString*)pURL data:(NSString*)pParameters;
- (void) connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response;
- (void) connection:(NSURLConnection*)connection didReceiveData:(NSData*)d;
- (void) connection:(NSURLConnection*)connection didFailWithError:(NSError*)error;
- (void) connectionDidFinishLoading:(NSURLConnection*)connection;
- (void) connection:(NSURLConnection*)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge*)challenge;

@end

@protocol HttpPostDelegate <NSObject>
@optional
- (void) httpPost:(HttpPost*)httpPost responseReceived:(NSString*)response;
- (void) httpPost:(HttpPost*)httpPost onError:(NSString*)message;
@end
