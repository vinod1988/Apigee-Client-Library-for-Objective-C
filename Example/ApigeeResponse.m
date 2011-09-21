//
//  ApigeeResponse.m
//  ApigeePrototype
//
//  Copyright 2011 Apigee. All rights reserved.
//

#import "ApigeeResponse.h"


@implementation ApigeeResponse

@synthesize request, formRequest, callback;

- (void)dealloc {
    [request release];
    [formRequest release];
    [callback release];
    [super dealloc];
}

@end
