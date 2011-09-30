//
//  ApigeeRequest.h
//  Apigee Client Library for Objective-C
//
//  Copyright 2011 Apigee. All rights reserved.
//

#import "ASIHTTPRequest.h"

@class APGUser;

@interface APGRequest : ASIHTTPRequest

@property (nonatomic, retain) NSURL *targetURL;
@property (nonatomic, retain) NSString *targetVerb;
@property (nonatomic, retain) NSDictionary *targetHeaders;
@property (nonatomic, retain) NSData *targetBody;

+ (APGRequest *)request:(NSURL *)url verb:(NSString *)verb headers:(NSDictionary *)headers body:(NSData *)body;
- (APGUser *)appUser;
- (BOOL)isSuccess;


@end
