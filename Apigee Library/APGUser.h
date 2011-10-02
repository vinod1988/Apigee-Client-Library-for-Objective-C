//
//  ApigeeUser.h
//  Apigee Client Library for Objective-C
//
//  Copyright 2011 Apigee. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 The APGUser class provides a representation of an application user in your app.
 */
@interface APGUser : NSObject

/**
 The unique identifier for the user
 */
@property (nonatomic, retain) NSString *appUserId;

/**
 The desired name or identifier for the user (an email address is recommended)
 */
@property (nonatomic, retain) NSString *username;

/**
 The user's password
 */
@property (nonatomic, retain) NSString *password;

/**
 The user's human-friendly display name
 */
@property (nonatomic, retain) NSString *fullName;

/**
 The user's smartKey, which is used for authentication/identification in API calls.
 This field is not available in GET user info API calls, so it is recommended that you
 persist the smartKey with the APGKeychain class
 @see APGKeychain
 */
@property (nonatomic, retain) NSString *smartKey;

/**
 The name of the application that prefixes the app endpoint
 */
@property (nonatomic, retain) NSString *appName;

/**
 Creates and returns a user with values based on those in the dictionary.  For example,
 the user's username property will be set to [dict objectForKey:@"username"].
 */
- (id)initWithJSONDict:(NSDictionary *)dict;

@end
