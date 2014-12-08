//
//  HttpPost.m
//  HorKonpon
//
//  Copyright (c) 2014 Kubbit Information Technology. All rights reserved.
//

#import "HttpPost.h"

@implementation HttpPost

float const TIMEOUT = 30.0;
@synthesize responseData;

- (id) init
{
	self = [super init];

	if (self != nil)
		self.responseData = [[NSMutableData alloc] init];

	return self;
}

+ (NSString*) urlEncode:(NSString*)pData
{
	CFStringRef safeString = CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)pData,
	 NULL, CFSTR("/%&=?$#+-~@<>|\\*,.()[]{}^!"), kCFStringEncodingUTF8);

	NSString *encoded = [NSString stringWithFormat:@"%@", safeString];
	CFRelease(safeString);

	return encoded;
}

- (void) send:(NSString*)pURL data:(NSString*)pData;
{
	NSURL *url = [NSURL URLWithString:pURL];
	NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
	[urlRequest setTimeoutInterval:TIMEOUT];
	[urlRequest setHTTPMethod:@"POST"];
	[urlRequest setHTTPBody:[pData dataUsingEncoding:NSUTF8StringEncoding]];

	NSURLConnection* connection = [NSURLConnection connectionWithRequest:urlRequest delegate:self];
	[connection start];
}

- (void) connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response
{
	[self.responseData setLength:0];
}

- (void) connection:(NSURLConnection*)connection didReceiveData:(NSData*)d
{
	[self.responseData appendData:d];
}

- (void) connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
	if ([self.delegate respondsToSelector:@selector(httpPost:onError:)])
		[self.delegate httpPost:self onError: [error localizedDescription]];
}

- (void) connectionDidFinishLoading:(NSURLConnection*)connection
{
	NSString* responseText = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];

	DebugLog(@"Response: %@", responseText);

	if ([self.delegate respondsToSelector:@selector(httpPost:responseReceived:)])
		[self.delegate httpPost:self responseReceived: responseText];
}

- (void) connection:(NSURLConnection*)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge*)challenge
{
	NSString* username = @"";
	NSString* password = @"";

	NSURLCredential* credential = [NSURLCredential credentialWithUser:username
	 password:password
	 persistence:NSURLCredentialPersistenceForSession];

	[[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
}
@end
