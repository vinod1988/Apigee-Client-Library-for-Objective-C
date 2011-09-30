//
//  ApigeeFormRequest.h
//  Apigee Client Library for Objective-C
//
//  Copyright 2011 Apigee. All rights reserved.
//

#import "ASIFormDataRequest.h"

@interface APGFormRequest : ASIFormDataRequest

@property (nonatomic, retain) NSURL *targetURL;
@property (nonatomic, retain) NSString *targetVerb;
@property (nonatomic, retain) NSDictionary *targetHeaders;
@property (nonatomic, retain) NSData *targetBody;

+ (APGFormRequest *)request:(NSURL *)url verb:(NSString *)verb headers:(NSDictionary *)headers;

@end
