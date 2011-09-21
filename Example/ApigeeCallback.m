//
//  ApigeeCallback.m
//  ApigeePrototype
//
//  Copyright 2011 Apigee. All rights reserved.
//

#import "ApigeeCallback.h"
#import "ApigeeAPI.h"
#import "ApigeeRequest.h"
#import "ApigeeFormRequest.h"


@implementation ApigeeCallback

@synthesize uuid, url, verb, client, request, formRequest;

+ (NSString *)stringWithUUID {
    CFUUIDRef uuidObj = CFUUIDCreate(nil);
    NSString *uuidString = (NSString*)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    return [uuidString autorelease];
}

- (id)initWithClient:(ApigeeAPI *)apigeeClient url:(NSURL *)targetURL {
    self = [super init];
    if (self) {
        self.uuid = [ApigeeCallback stringWithUUID];
        self.url = targetURL;
        self.verb = @"GET";
        self.client = apigeeClient;
    }
    return self;
}

- (id)initWithClient:(ApigeeAPI *)apigeeClient url:(NSURL *)targetURL verb:(NSString *)requestVerb {
    self = [super init];
    if (self) {
        self.uuid = [ApigeeCallback stringWithUUID];
        self.url = targetURL;
        self.verb = requestVerb;
        self.client = apigeeClient;
    }
    return self;
}

- (id)initWithClient:(ApigeeAPI *)apigeeClient request:(ApigeeRequest *)apigeeRequest {
    self = [super init];
    if (self) {
        self.uuid = [ApigeeCallback stringWithUUID];
        self.url = apigeeRequest.targetURL;
        self.verb = apigeeRequest.targetVerb;
        self.client = apigeeClient;
        self.request = apigeeRequest;
    }
    return self;
}

- (id)initWithClient:(ApigeeAPI *)apigeeClient formRequest:(ApigeeFormRequest *)apigeeFormRequest {
    self = [super init];
    if (self) {
        self.uuid = [ApigeeCallback stringWithUUID];
        self.url = apigeeFormRequest.targetURL;
        self.verb = apigeeFormRequest.targetVerb;
        self.client = apigeeClient;
        self.formRequest = apigeeFormRequest;
    }
    return self;
}

- (void)success:(ApigeeResponseBlock)successBlock failure:(ApigeeResponseBlock)failureBlock {
    // TODO: option to stop observing from observe style?    
    NSString *successName = [NSString stringWithFormat:@"SUCCESS %@ %@%@", self.verb, [self.url description], ((request || formRequest) ? [NSString stringWithFormat:@" %@", self.uuid] : @"")];
    successObserver = [[NSNotificationCenter defaultCenter] addObserverForName:successName object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification)
    {
        successBlock([notification.userInfo objectForKey:@"apigeeResponse"]);
        if (self.request || self.formRequest) {
            [[NSNotificationCenter defaultCenter] removeObserver:successObserver];
            [[NSNotificationCenter defaultCenter] removeObserver:failureObserver];
        }
    }];
    
    NSString *failureName = [NSString stringWithFormat:@"FAILURE %@ %@%@", self.verb, [self.url description], ((request || formRequest) ? [NSString stringWithFormat:@" %@", self.uuid] : @"")];
    failureObserver = [[NSNotificationCenter defaultCenter] addObserverForName:failureName object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification)
    {
        failureBlock([notification.userInfo objectForKey:@"apigeeResponse"]);
        if (self.request || self.formRequest) {
            [[NSNotificationCenter defaultCenter] removeObserver:successObserver];
            [[NSNotificationCenter defaultCenter] removeObserver:failureObserver];
        }
    }];    
}

- (void)dealloc {
    [uuid release];
    [url release];
    [verb release];
    [client release];
    [formRequest release];
    [super dealloc];
}

@end
