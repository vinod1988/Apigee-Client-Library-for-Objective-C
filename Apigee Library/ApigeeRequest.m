//
//  ApigeeRequest.m
//  ApigeePrototype
//
//  Copyright 2011 Apigee. All rights reserved.
//

#import "ApigeeRequest.h"
#import "ApigeeConstants.h"
#import "ApigeeCallback.h"
#import "ApigeeResponse.h"
#import "JSONKit.h"


@implementation ApigeeRequest

@synthesize targetURL, targetVerb, targetHeaders, targetBody, callback;

- (BOOL)isSuccess {
	return (200 <= [self responseStatusCode]) && ([self responseStatusCode] <= 299);
}

- (ApigeeUser *)appUser {
    NSDictionary *json = [[self responseString] objectFromJSONString];
    return [[[ApigeeUser alloc] initWithJSONDict:json] autorelease];
}

#pragma mark - Request

+ (ApigeeRequest *)request:(NSURL *)url verb:(NSString *)verb headers:(NSDictionary *)headers body:(NSData *)body {
	ApigeeRequest *request = [[[ApigeeRequest alloc] initWithURL:[NSURL URLWithString:ApigeeProxyURLString]] autorelease];
    
    request.targetURL = url;
    request.targetVerb = verb;
    request.targetHeaders = headers;
    request.targetBody = [NSMutableData dataWithData:body];
    
    request.requestMethod = verb;
    request.requestHeaders = [NSMutableDictionary dictionaryWithDictionary:headers];
    request.postBody = [NSMutableData dataWithData:body];
    request.url = request.targetURL;
    
    // TODO: this should eventually be removed
    request.validatesSecureCertificate = NO;
	
    return request;
}

- (void)notify:(NSString *)name {
    ApigeeResponse *apigeeResponse = [[[ApigeeResponse alloc] init] autorelease];
    apigeeResponse.request = self;    
    apigeeResponse.callback = self.callback;
    NSDictionary *apigeeUserInfo = [NSDictionary dictionaryWithObject:apigeeResponse forKey:@"apigeeResponse"];
    
    NSNotification *notification = [NSNotification notificationWithName:name object:nil userInfo:apigeeUserInfo];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (void)notify {
    [self notify:[NSString stringWithFormat:@"%@ %@ %@", [self isSuccess] ? @"SUCCESS" : @"FAILURE", self.targetVerb, [self.targetURL description]]];
    [self notify:[NSString stringWithFormat:@"%@ %@ %@ %@", [self isSuccess] ? @"SUCCESS" : @"FAILURE", self.targetVerb, [self.targetURL description], self.callback.uuid]];
}

#pragma mark -
#pragma mark ASIHTTPRequest Overrides

- (void)requestFinished {
    [self notify];
    [super requestFinished];
}

- (void)failWithError:(NSError *)theError {
    [self notify];
    NSLog(@"Error from %@ %@: %@", self.requestMethod, self.url, theError);
    [super failWithError:theError];
}

#pragma mark -
#pragma mark Memory Management

- (void)dealloc {
    [targetURL release];
    [targetVerb release];
    [targetHeaders release];
    [targetBody release];
    [callback release];
    [super dealloc];
}

@end
