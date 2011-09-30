//
//  ApigeeRequest.m
//  Apigee Client Library for Objective-C
//
//  Copyright 2011 Apigee. All rights reserved.
//

#import "APGRequest.h"
#import "APGConstants.h"
#import "JSONKit.h"
#import "APGUser.h"


@implementation APGRequest

@synthesize targetURL, targetVerb, targetHeaders, targetBody;

- (BOOL)isSuccess {
	return (200 >= [self responseStatusCode]) && ([self responseStatusCode] <= 299);
}

- (APGUser *)appUser {
    NSDictionary *json = [[self responseString] objectFromJSONString];
    return [[[APGUser alloc] initWithJSONDict:json] autorelease];
}

#pragma mark - Request

+ (APGRequest *)request:(NSURL *)url verb:(NSString *)verb headers:(NSDictionary *)headers body:(NSData *)body {
	APGRequest *request = [[[APGRequest alloc] initWithURL:[NSURL URLWithString:ApigeeProxyURLString]] autorelease];
    
    request.targetURL = url;
    request.targetVerb = verb;
    request.targetHeaders = headers;
    request.targetBody = [NSMutableData dataWithData:body];
    
    request.requestMethod = verb;
    request.requestHeaders = [NSMutableDictionary dictionaryWithDictionary:headers];
    request.postBody = [NSMutableData dataWithData:body];
    request.url = request.targetURL;
    
    return request;
}

#pragma mark - Memory Management

- (void)dealloc {
    [targetURL release];
    [targetVerb release];
    [targetHeaders release];
    [targetBody release];
    [super dealloc];
}

@end
