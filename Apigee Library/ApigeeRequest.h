//
//  ApigeeRequest.h
//  ApigeePrototype
//
//  Copyright 2011 Apigee. All rights reserved.
//

#import "ASIHTTPRequest.h"

@class ApigeeCallback, ApigeeUser;

@interface ApigeeRequest : ASIHTTPRequest {
}

@property (nonatomic, retain) NSURL *targetURL;
@property (nonatomic, retain) NSString *targetVerb;
@property (nonatomic, retain) NSDictionary *targetHeaders;
@property (nonatomic, retain) NSData *targetBody;
@property (nonatomic, retain) ApigeeCallback *callback;

+ (ApigeeRequest *)request:(NSURL *)url verb:(NSString *)verb headers:(NSDictionary *)headers body:(NSData *)body;
- (ApigeeUser *)appUser;
- (BOOL)isSuccess;


@end
