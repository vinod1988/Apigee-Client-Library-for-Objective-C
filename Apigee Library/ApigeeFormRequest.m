//
//  ApigeeFormRequest.m
//  ApigeePrototype
//
//  Copyright 2011 Apigee. All rights reserved.
//

#import "ApigeeFormRequest.h"
#import "ApigeeConstants.h"
#import "ApigeeCallback.h"
#import "ApigeeResponse.h"


@implementation ApigeeFormRequest

@synthesize targetURL, targetVerb, targetHeaders, targetBody, callback;

+ (ApigeeFormRequest *)request:(NSURL *)url verb:(NSString *)verb headers:(NSDictionary *)headers {
	ApigeeFormRequest *request = [[[ApigeeFormRequest alloc] initWithURL:[NSURL URLWithString:ApigeeProxyURLString]] autorelease];
    
    request.targetURL = url;
    request.targetVerb = verb;
    request.targetHeaders = headers;
    request.requestMethod = @"GET"; 
    request.requestHeaders = [NSMutableDictionary dictionaryWithDictionary:headers];
    //request.postBody = nil;
    request.url = request.targetURL;
	
    // TODO: this should eventually be removed
    request.validatesSecureCertificate = NO;
    
    request.username = @"Developer1";
    request.password = @"secret";
    
    NSLog(@"auth: %@:%@", request.username, request.password);
    
    return request;
}

- (BOOL)isSuccess {
	return (200 <= [self responseStatusCode]) && ([self responseStatusCode] <= 299);
}

- (void)notify:(NSString *)name {
    ApigeeResponse *apigeeResponse = [[[ApigeeResponse alloc] init] autorelease];
    apigeeResponse.formRequest = self;    
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
