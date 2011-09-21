//
//  ApigeeFormRequest.h
//  ApigeePrototype
//
//  Copyright 2011 Apigee. All rights reserved.
//

#import "ASIFormDataRequest.h"

@class ApigeeCallback;

@interface ApigeeFormRequest : ASIFormDataRequest {
}

@property (nonatomic, retain) NSURL *targetURL;
@property (nonatomic, retain) NSString *targetVerb;
@property (nonatomic, retain) NSDictionary *targetHeaders;
@property (nonatomic, retain) NSData *targetBody;
@property (nonatomic, retain) ApigeeCallback *callback;

+ (ApigeeFormRequest *)request:(NSURL *)url verb:(NSString *)verb headers:(NSDictionary *)headers;

@end
