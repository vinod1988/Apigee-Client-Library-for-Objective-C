//
//  ApigeeUser.m
//  Apigee Client Library for Objective-C
//
//  Copyright 2011 Apigee. All rights reserved.
//

#import "APGUser.h"

@implementation APGUser

@synthesize appUserId, username, password, fullName, smartKey, appName;

- (void)populateWithJSONDict:(NSDictionary *)dict {
    self.appUserId = [dict objectForKey:@"applicationUserId"];
    self.fullName = [dict objectForKey:@"fullName"];
    self.smartKey = [dict objectForKey:@"smartKey"];
    NSLog(@"smart key: %@", self.smartKey);
    self.username = [dict objectForKey:@"userName"];
    self.appName = [dict objectForKey:@"appName"];    
}

- (id)initWithJSONDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        [self populateWithJSONDict:dict];
    }    
    return self;
}

- (void)dealloc {
    [appUserId release];
    [username release];
    [password release];
    [fullName release];
    [smartKey release];
    [appName release];
    [super dealloc];
}

@end
