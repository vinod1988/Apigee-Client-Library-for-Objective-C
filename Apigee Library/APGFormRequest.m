//
//  ApigeeFormRequest.m
//  Apigee Client Library for Objective-C
//
//  Copyright 2011 Apigee. All rights reserved.
//

#import "APGFormRequest.h"
#import "APGConstants.h"


@implementation APGFormRequest

@synthesize targetURL, targetVerb, targetHeaders, targetBody;

+ (APGFormRequest *)request:(NSURL *)url verb:(NSString *)verb headers:(NSDictionary *)headers {
	APGFormRequest *request = [[[APGFormRequest alloc] initWithURL:[NSURL URLWithString:ApigeeProxyURLString]] autorelease];
    
    request.targetURL = url;
    request.targetVerb = verb;
    request.targetHeaders = headers;
    request.requestMethod = @"GET"; 
    request.requestHeaders = [NSMutableDictionary dictionaryWithDictionary:headers];
    //request.postBody = nil;
    request.url = request.targetURL;
	
    request.username = @"Developer1";
    request.password = @"secret";
        
    return request;
}

- (BOOL)isSuccess {
	return (200 <= [self responseStatusCode]) && ([self responseStatusCode] <= 299);
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
