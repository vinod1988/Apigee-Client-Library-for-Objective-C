//
//  ApigeeUser.m
//  ApigeePrototype
//
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ApigeeUser.h"

@implementation ApigeeUser

@synthesize appUserId, username, password, fullName, smartKey, appName;

- (void)populateWithJSONDict:(NSDictionary *)dict {
    self.appUserId = [dict objectForKey:@"applicationUserId"];
    self.fullName = [dict objectForKey:@"fullName"];
    self.smartKey = [dict objectForKey:@"smartKey"];
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
