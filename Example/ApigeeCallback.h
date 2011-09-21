//
//  ApigeeCallback.h
//  ApigeePrototype
//
//  Copyright 2011 Apigee. All rights reserved.
//

#import "ApigeeAPI.h"

@class ApigeeAPI, ApigeeRequest, ApigeeFormRequest;

/**
 The ApigeeCallback class provides a simple way to handle success and failure responses
 from an ApigeeAPI object.
 
 @see ApigeeAPI
*/
@interface ApigeeCallback : NSObject {
    id successObserver;
    id failureObserver;
}

@property (nonatomic, retain) NSString *uuid;
@property (nonatomic, retain) NSURL *url;
@property (nonatomic, retain) NSString *verb;
@property (nonatomic, retain) ApigeeAPI *client;
@property (nonatomic, assign) ApigeeRequest *request;
@property (nonatomic, retain) ApigeeFormRequest *formRequest;

- (id)initWithClient:(ApigeeAPI *)client url:(NSURL *)url;
- (id)initWithClient:(ApigeeAPI *)client url:(NSURL *)url verb:(NSString *)verb;
- (id)initWithClient:(ApigeeAPI *)client request:(ApigeeRequest *)request;
- (id)initWithClient:(ApigeeAPI *)client formRequest:(ApigeeFormRequest *)request;


- (void)success:(ApigeeResponseBlock)successBlock failure:(ApigeeResponseBlock)failureBlock;

@end
