//
//  ApigeeResponse.h
//  ApigeePrototype
//
//  Copyright 2011 Apigee. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ApigeeRequest, ApigeeFormRequest, ApigeeCallback;

@interface ApigeeResponse : NSObject {
}

@property (nonatomic, retain) ApigeeRequest *request;
@property (nonatomic, retain) ApigeeFormRequest *formRequest;
@property (nonatomic, retain) ApigeeCallback *callback;

@end
