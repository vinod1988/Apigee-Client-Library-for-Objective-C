//
//  ApigeeUser.h
//  ApigeePrototype
//
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApigeeUser : NSObject

@property (nonatomic, retain) NSString *appUserId;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *fullName;
@property (nonatomic, retain) NSString *smartKey;
@property (nonatomic, retain) NSString *appName;

- (id)initWithJSONDict:(NSDictionary *)dict;

@end
