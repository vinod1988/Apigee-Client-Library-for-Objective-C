//
//  APGClient.h
//  Apigee Client Library for Objective-C
//
//  Copyright 2011 Apigee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APGUser.h"
#import "APGKeychain.h"
#import "APGConstants.h"

@class APGResponse;

#if TARGET_OS_IPHONE
// APGLoginViewController is only available for iOS apps.
@class APGLoginViewController;
#endif

typedef void (^APGResponseBlock)(NSHTTPURLResponse *response, NSData *data, NSError *error);

/**
 The APGClient class provides a simple way to talk to your APIs through 
 Apigee.  It provides several convenience methods to create HTTP requests
 and send them. 
 */
@interface APGClient : NSObject

@property (nonatomic, retain) NSString *endpoint;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *smartKey;

#if TARGET_OS_IPHONE

/**
 The OAuth login view controller presented with presentLoginForProvider:fromViewController:
 */
@property (nonatomic, retain) APGLoginViewController *loginViewController;

/**
 Displays the OAuth login page for the provider specified.  To hide the view controller
 after a successful login, you must set up a custom URL scheme for your app, override 
 application:openURL:sourceApplication:annotation: in your app delegate, and call
 dismissModalViewControllerAnimated: on the APGClient's loginViewController object
 */
- (void)presentLoginForProvider:(NSString *)provider fromViewController:(UIViewController *)fromViewController;

#endif

/**
 Creates and returns an APGClient object for you to use to make REST API calls.
 @param endpoint Your Apigee app name
 @return APGClient object for you to use to make REST API calls
 */
+ (APGClient *)sharedAPI:(NSString *)appName;

/**
 Creates and returns an APGClient object for you to use to make REST API calls.
 @param endpoint Your Apigee app name
 @param username Your Apigee username
 @param password Your Apigee password
 @return APGClient object for you to use to make REST API calls
 */
+ (APGClient *)sharedAPI:(NSString *)appName username:(NSString *)username password:(NSString *)password;

/**
 Attempts to load the smart key for the APGClient object's user.  You must have a
 username and password set on the APGClient object to use this method.
 */
- (void)loadMySmartKey:(APGResponseBlock)completionBlock;

/**
 Returns the OAuth page URL for the provider specified.  This is the URL used for the
 APGLoginViewController's web view on iOS apps.
 */
- (NSURL *)authURLForProvider:(NSString *)provider callbackURL:(NSURL *)callbackURL;

/**
 Creates an application user.  The data in the completion callback will contain the JSON
 for that user.  To authenticate as that user later, you will need to persist either the
 username and password or the smartKey in the response.
 */
- (void)createAppUser:(NSString *)username password:(NSString *)password completion:(APGResponseBlock)completionBlock;

/**
 Returns a request object for the path and verb specified.
 */
- (NSMutableURLRequest *)request:(NSString *)path verb:(NSString *)verb;

/**
 Returns a request object for the path, verb, and headers specified.
 */
- (NSMutableURLRequest *)request:(NSString *)path verb:(NSString *)verb headers:(NSDictionary *)headers;

/**
 Returns a request object for the path, verb, headers, and request body specified.
 */
- (NSMutableURLRequest *)request:(NSString *)path verb:(NSString *)verb headers:(NSDictionary *)headers body:(NSData *)body;

/**
 Performs a request.
 */
- (void)call:(NSString *)path verb:(NSString *)verb completion:(APGResponseBlock)completionBlock;

/**
 Returns the URL for the path specified.
 */
- (NSURL *)URLForPath:(NSString *)path;

/**
 Performs an HTTP GET request to the specified path 
 @param path Path to the resource.
 */
- (void)get:(NSString *)path completion:(APGResponseBlock)completionBlock;

/**
 Performs an HTTP GET request to the specified path 
 @param path Path to the resource
 @param headers Dictionary of HTTP headers where the keys are the header names and
 the values are the header values
 */
- (void)get:(NSString *)path headers:(NSDictionary *)headers completion:(APGResponseBlock)completionBlock;

/**
 Performs an HTTP GET request to the specified path 
 @param path Path to the resource
 @param headers Dictionary of HTTP headers where the keys are the header names and
 the values are the header values
 */
- (void)get:(NSString *)path headers:(NSDictionary *)headers body:(NSData *)data completion:(APGResponseBlock)completionBlock;

/**
 Performs an HTTP GET request to the specified path 
 @param path Path to the resource
 @param data HTTP body
 */
- (void)get:(NSString *)path body:(NSData *)data completion:(APGResponseBlock)completionBlock;

/**
 Performs an HTTP PUT request to the specified path 
 @param path Path to the resource.
 */
- (void)put:(NSString *)path completion:(APGResponseBlock)completionBlock;

/**
 Performs an HTTP PUT request to the specified path 
 @param path Path to the resource
 @param headers Dictionary of HTTP headers where the keys are the header names and
 the values are the header values
 */
- (void)put:(NSString *)path headers:(NSDictionary *)headers completion:(APGResponseBlock)completionBlock;

/**
 Performs an HTTP PUT request to the specified path 
 @param path Path to the resource
 @param headers Dictionary of HTTP headers where the keys are the header names and
 the values are the header values
 @param data HTTP body
 */
- (void)put:(NSString *)path headers:(NSDictionary *)headers body:(NSData *)data completion:(APGResponseBlock)completionBlock;

/**
 Performs an HTTP PUT request to the specified path 
 @param path Path to the resource
 @param data HTTP body
 */
- (void)put:(NSString *)path body:(NSData *)data completion:(APGResponseBlock)completionBlock;

/**
 Performs an HTTP POST request to the specified path 
 @param path Path to the resource
 */
- (void)post:(NSString *)path completion:(APGResponseBlock)completionBlock;

/**
 Performs an HTTP POST request to the specified path 
 @param path Path to the resource
 @param headers Dictionary of HTTP headers where the keys are the header names and
 the values are the header values
 */
- (void)post:(NSString *)path headers:(NSDictionary *)headers completion:(APGResponseBlock)completionBlock;

/**
 Performs an HTTP POST request to the specified path 
 @param path Path to the resource
 @param headers Dictionary of HTTP headers where the keys are the header names and
 the values are the header values
 @param data HTTP body
 */
- (void)post:(NSString *)path headers:(NSDictionary *)headers body:(NSData *)data completion:(APGResponseBlock)completionBlock;

/**
 Performs an HTTP POST request to the specified path 
 @param path Path to the resource
 @param data HTTP body
 */
- (void)post:(NSString *)path body:(NSData *)data completion:(APGResponseBlock)completionBlock;

/**
 Performs an HTTP DELETE request to the specified path 
 @param path Path to the resource
 */
- (void)delete:(NSString *)path completion:(APGResponseBlock)completionBlock;

/**
 Performs an HTTP DELETE request to the specified path 
 @param path Path to the resource
 @param headers Dictionary of HTTP headers where the keys are the header names and
 the values are the header values
 */
- (void)delete:(NSString *)path headers:(NSDictionary *)headers completion:(APGResponseBlock)completionBlock;

/**
 Performs an HTTP DELETE request to the specified path 
 @param path Path to the resource
 @param headers Dictionary of HTTP headers where the keys are the header names and
 the values are the header values
 @param data HTTP body
 */
- (void)delete:(NSString *)path headers:(NSDictionary *)headers body:(NSData *)data completion:(APGResponseBlock)completionBlock;

/**
 Performs an HTTP DELETE request to the specified path 
 @param path Path to the resource
 @param data HTTP body
 */
- (void)delete:(NSString *)path body:(NSData *)data completion:(APGResponseBlock)completionBlock;

/**
 Performs an HTTP HEAD request to the specified path 
 @param path Path to the resource
 */
- (void)head:(NSString *)path completion:(APGResponseBlock)completionBlock;

/**
 Performs an HTTP HEAD request to the specified path 
 @param path Path to the resource
 @param headers Dictionary of HTTP headers where the keys are the header names and
 the values are the header values
 */
- (void)head:(NSString *)path headers:(NSDictionary *)headers completion:(APGResponseBlock)completionBlock;

/**
 Performs an HTTP HEAD request to the specified path 
 @param path Path to the resource
 @param headers Dictionary of HTTP headers where the keys are the header names and
 the values are the header values
 @param data HTTP body
 */
- (void)head:(NSString *)path headers:(NSDictionary *)headers body:(NSData *)data completion:(APGResponseBlock)completionBlock;

/**
 Performs an HTTP HEAD request to the specified path 
 @param path Path to the resource
 @param data HTTP body
 */
- (void)head:(NSString *)path body:(NSData *)data completion:(APGResponseBlock)completionBlock;

/**
 Performs an HTTP request to the specified path 
 @param path Path to the resource
 @param verb The HTTP method (e.g. GET, PUT, POST, etc.)
 */
- (void)call:(NSString *)path verb:(NSString *)verb completion:(APGResponseBlock)completionBlock;

/**
 Performs an HTTP request to the specified path 
 @param path Path to the resource
 @param verb The HTTP method (e.g. GET, PUT, POST, etc.)
 @param headers Dictionary of HTTP headers where the keys are the header names and
 the values are the header values
 */
- (void)call:(NSString *)path verb:(NSString *)verb headers:(NSDictionary *)headers completion:(APGResponseBlock)completionBlock;

/**
 Performs an HTTP request to the specified path 
 @param path Path to the resource
 @param verb The HTTP method (e.g. GET, PUT, POST, etc.)
 @param body HTTP body
 */
- (void)call:(NSString *)path verb:(NSString *)verb body:(NSData *)body completion:(APGResponseBlock)completionBlock;

/**
 Performs an HTTP request to the specified path 
 @param path Path to the resource
 @param verb The HTTP method (e.g. GET, PUT, POST, etc.)
 @param headers Dictionary of HTTP headers where the keys are the header names and
 the values are the header values
 @param body HTTP body
 */
- (void)call:(NSString *)path verb:(NSString *)verb headers:(NSDictionary *)headers body:(NSData *)body completion:(APGResponseBlock)completionBlock;

@end
