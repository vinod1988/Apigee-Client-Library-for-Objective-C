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
 */
@property (nonatomic, retain) APGLoginViewController *loginViewController;


- (void)presentLoginForProvider:(NSString *)provider fromViewController:(UIViewController *)fromViewController;

#endif

/**
 Creates and returns an APGClient object for you to use to make REST API calls.
 @param endpoint Your Apigee app name
 @return APGClient object for you to use to make REST API calls
 
 <h4 class="method-subtitle parameter-title">Example Usage</h4>
 APGClient *api = [APGClient api:@"myapp" username:@"user" password:@"pass"];
 */
+ (APGClient *)sharedAPI:(NSString *)appName;

/**
 Creates and returns an APGClient object for you to use to make REST API calls.
 @param endpoint Your Apigee app name
 @param username Your Apigee username
 @param password Your Apigee password
 @return APGClient object for you to use to make REST API calls
 
 <h4 class="method-subtitle parameter-title">Example Usage</h4>
    APGClient *api = [APGClient api:@"myapp" username:@"user" password:@"pass"];
 */
+ (APGClient *)sharedAPI:(NSString *)appName username:(NSString *)username password:(NSString *)password;

- (void)loadMySmartKey:(APGResponseBlock)completionBlock;

- (NSURL *)authURLForProvider:(NSString *)provider callbackURL:(NSURL *)callbackURL;

- (void)createAppUser:(NSString *)username password:(NSString *)password completion:(APGResponseBlock)completionBlock;

- (NSMutableURLRequest *)request:(NSString *)path verb:(NSString *)verb;
- (NSMutableURLRequest *)request:(NSString *)path verb:(NSString *)verb headers:(NSDictionary *)headers;
- (NSMutableURLRequest *)request:(NSString *)path verb:(NSString *)verb headers:(NSDictionary *)headers body:(NSData *)body;

- (void)call:(NSString *)path verb:(NSString *)verb completion:(APGResponseBlock)completionBlock;

- (NSURL *)URLForPath:(NSString *)path;

/**
 Performs an HTTP GET request to the specified path 
 @param path Path to the resource.

 <b>Example Usage</b>
    [[api get:@"/statuses/public_timeline.json"] success:^(ApigeeResponse *response) {
        // handle success
    } failure:^(ApigeeResponse *response) {
        // handle failure
    }];
 */
- (void)get:(NSString *)path completion:(APGResponseBlock)completionBlock;

/**
 Performs an HTTP GET request to the specified path 
 @param path Path to the resource
 @param headers Dictionary of HTTP headers where the keys are the header names and
 the values are the header values
 
 <b>Example Usage</b>
    NSDictionary *headers = [NSDictionary dictionaryWithObject:@"application/json" forKey:@"Accept"];
    [[api get:@"/statuses/public_timeline.json" headers:headers] success:^(ApigeeResponse *response) {
        // handle success
    } failure:^(ApigeeResponse *response) {
        // handle failure
    }];
 */
- (void)get:(NSString *)path headers:(NSDictionary *)headers completion:(APGResponseBlock)completionBlock;

/**
 Performs an HTTP GET request to the specified path 
 @param path Path to the resource
 @param headers Dictionary of HTTP headers where the keys are the header names and
 the values are the header values
 
 <b>Example Usage</b>
    NSDictionary *headers = [NSDictionary dictionaryWithObject:@"application/json" forKey:@"Accept"];
    [[api get:@"/statuses/public_timeline.json" headers:headers] success:^(ApigeeResponse *response) {
        // handle success
    } failure:^(ApigeeResponse *response) {
        // handle failure
    }];
 */
- (void)get:(NSString *)path headers:(NSDictionary *)headers body:(NSData *)data completion:(APGResponseBlock)completionBlock;

/**
 Performs an HTTP GET request to the specified path 
 @param path Path to the resource
 @param data HTTP body
 
 <b>Example Usage</b>
    [[api get:@"/statuses/public_timeline.json" body:body] success:^(ApigeeResponse *response) {
        // handle success
    } failure:^(ApigeeResponse *response) {
        // handle failure
    }];
 */
- (void)get:(NSString *)path body:(NSData *)data completion:(APGResponseBlock)completionBlock;

/**
 Performs an HTTP PUT request to the specified path 
 @param path Path to the resource.
 
 <b>Example Usage</b>
    [[api put:@"/statuses/public_timeline.json"] success:^(ApigeeResponse *response) {
        // handle success
    } failure:^(ApigeeResponse *response) {
        // handle failure
    }];
 */
- (void)put:(NSString *)path completion:(APGResponseBlock)completionBlock;

/**
 Performs an HTTP PUT request to the specified path 
 @param path Path to the resource
 @param headers Dictionary of HTTP headers where the keys are the header names and
 the values are the header values
 
 <b>Example Usage</b>
    NSDictionary *headers = [NSDictionary dictionaryWithObject:@"application/json" forKey:@"Accept"];
    [[api put:@"/statuses/public_timeline.json" headers:headers] success:^(ApigeeResponse *response) {
        // handle success
    } failure:^(ApigeeResponse *response) {
        // handle failure
    }];
 */
- (void)put:(NSString *)path headers:(NSDictionary *)headers completion:(APGResponseBlock)completionBlock;

/**
 Performs an HTTP PUT request to the specified path 
 @param path Path to the resource
 @param headers Dictionary of HTTP headers where the keys are the header names and
 the values are the header values
 @param data HTTP body
 
 <b>Example Usage</b>
    NSDictionary *headers = [NSDictionary dictionaryWithObject:@"application/json" forKey:@"Accept"];
    [[api put:@"/statuses/public_timeline.json" headers:headers body:body] success:^(ApigeeResponse *response) {
        // handle success
    } failure:^(ApigeeResponse *response) {
        // handle failure
    }];
 */
- (void)put:(NSString *)path headers:(NSDictionary *)headers body:(NSData *)data completion:(APGResponseBlock)completionBlock;

/**
 Performs an HTTP PUT request to the specified path 
 @param path Path to the resource
 @param data HTTP body
 
 <b>Example Usage</b>
    [[api put:@"/statuses/public_timeline.json" body:body] success:^(ApigeeResponse *response) {
        // handle success
    } failure:^(ApigeeResponse *response) {
        // handle failure
    }];
 */
- (void)put:(NSString *)path body:(NSData *)data completion:(APGResponseBlock)completionBlock;

/**
 Performs an HTTP POST request to the specified path 
 @param path Path to the resource
 
 <b>Example Usage</b>
    [[api post:@"/statuses/public_timeline.json"] success:^(ApigeeResponse *response) {
        // handle success
    } failure:^(ApigeeResponse *response) {
        // handle failure
    }];
 */
- (void)post:(NSString *)path completion:(APGResponseBlock)completionBlock;

/**
 Performs an HTTP POST request to the specified path 
 @param path Path to the resource
 @param headers Dictionary of HTTP headers where the keys are the header names and
 the values are the header values
 
 <b>Example Usage</b>
    [[api post:@"/statuses/public_timeline.json"] success:^(ApigeeResponse *response) {
        // handle success
    } failure:^(ApigeeResponse *response) {
        // handle failure
    }];
 */
- (void)post:(NSString *)path headers:(NSDictionary *)headers completion:(APGResponseBlock)completionBlock;

/**
 Performs an HTTP POST request to the specified path 
 @param path Path to the resource
 @param headers Dictionary of HTTP headers where the keys are the header names and
 the values are the header values
 @param data HTTP body
 
 <b>Example Usage</b>
    [[api post:@"/statuses/public_timeline.json"] success:^(ApigeeResponse *response) {
        // handle success
    } failure:^(ApigeeResponse *response) {
        // handle failure
    }];
 */
- (void)post:(NSString *)path headers:(NSDictionary *)headers body:(NSData *)data completion:(APGResponseBlock)completionBlock;

/**
 Performs an HTTP POST request to the specified path 
 @param path Path to the resource
 @param data HTTP body
 
 <b>Example Usage</b>
    [[api post:@"/statuses/public_timeline.json"] success:^(ApigeeResponse *response) {
        // handle success
    } failure:^(ApigeeResponse *response) {
        // handle failure
    }];
 */
- (void)post:(NSString *)path body:(NSData *)data completion:(APGResponseBlock)completionBlock;

/**
 Performs an HTTP DELETE request to the specified path 
 @param path Path to the resource
 
 <b>Example Usage</b>
    [[api post:@"/statuses/public_timeline.json"] success:^(ApigeeResponse *response) {
        // handle success
    } failure:^(ApigeeResponse *response) {
        // handle failure
    }];
 */
- (void)delete:(NSString *)path completion:(APGResponseBlock)completionBlock;

/**
 Performs an HTTP DELETE request to the specified path 
 @param path Path to the resource
 @param headers Dictionary of HTTP headers where the keys are the header names and
 the values are the header values
 
 <b>Example Usage</b>
    [[api post:@"/statuses/public_timeline.json"] success:^(ApigeeResponse *response) {
        // handle success
    } failure:^(ApigeeResponse *response) {
        // handle failure
    }];
 */
- (void)delete:(NSString *)path headers:(NSDictionary *)headers completion:(APGResponseBlock)completionBlock;

/**
 Performs an HTTP DELETE request to the specified path 
 @param path Path to the resource
 @param headers Dictionary of HTTP headers where the keys are the header names and
 the values are the header values
 @param data HTTP body
 
 <b>Example Usage</b>
    [[api post:@"/statuses/public_timeline.json"] success:^(ApigeeResponse *response) {
        // handle success
    } failure:^(ApigeeResponse *response) {
        // handle failure
    }];
 */
- (void)delete:(NSString *)path headers:(NSDictionary *)headers body:(NSData *)data completion:(APGResponseBlock)completionBlock;

/**
 Performs an HTTP DELETE request to the specified path 
 @param path Path to the resource
 @param data HTTP body
 
 <b>Example Usage</b>
    [[api post:@"/statuses/public_timeline.json"] success:^(ApigeeResponse *response) {
        // handle success
    } failure:^(ApigeeResponse *response) {
        // handle failure
    }];
 */
- (void)delete:(NSString *)path body:(NSData *)data completion:(APGResponseBlock)completionBlock;

/**
 Performs an HTTP HEAD request to the specified path 
 @param path Path to the resource
 
 <b>Example Usage</b>
    [[api post:@"/statuses/public_timeline.json"] success:^(ApigeeResponse *response) {
        // handle success
    } failure:^(ApigeeResponse *response) {
        // handle failure
    }];
 */
- (void)head:(NSString *)path completion:(APGResponseBlock)completionBlock;

/**
 Performs an HTTP HEAD request to the specified path 
 @param path Path to the resource
 @param headers Dictionary of HTTP headers where the keys are the header names and
 the values are the header values
 
 <b>Example Usage</b>
    [[api post:@"/statuses/public_timeline.json"] success:^(ApigeeResponse *response) {
        // handle success
    } failure:^(ApigeeResponse *response) {
        // handle failure
    }];
 */
- (void)head:(NSString *)path headers:(NSDictionary *)headers completion:(APGResponseBlock)completionBlock;

/**
 Performs an HTTP HEAD request to the specified path 
 @param path Path to the resource
 @param headers Dictionary of HTTP headers where the keys are the header names and
 the values are the header values
 @param postParams Dictionary of form data where the keys are the form fields and
 the values are the form values
 
 <b>Example Usage</b>
    [[api post:@"/statuses/public_timeline.json"] success:^(ApigeeResponse *response) {
        // handle success
    } failure:^(ApigeeResponse *response) {
        // handle failure
    }];
 */
- (void)head:(NSString *)path headers:(NSDictionary *)headers body:(NSData *)data completion:(APGResponseBlock)completionBlock;

/**
 Performs an HTTP HEAD request to the specified path 
 @param path Path to the resource
 @param data HTTP body
 
 <b>Example Usage</b>
    [[api post:@"/statuses/public_timeline.json"] success:^(ApigeeResponse *response) {
        // handle success
    } failure:^(ApigeeResponse *response) {
        // handle failure
    }];
 */
- (void)head:(NSString *)path body:(NSData *)data completion:(APGResponseBlock)completionBlock;

/**
 Performs an HTTP request to the specified path 
 @param path Path to the resource
 @param verb The HTTP method (e.g. GET, PUT, POST, etc.)
 
 <b>Example Usage</b>
    [[api post:@"/statuses/public_timeline.json"] success:^(ApigeeResponse *response) {
        // handle success
    } failure:^(ApigeeResponse *response) {
        // handle failure
    }];
 */
- (void)call:(NSString *)path verb:(NSString *)verb completion:(APGResponseBlock)completionBlock;

/**
 Performs an HTTP request to the specified path 
 @param path Path to the resource
 @param verb The HTTP method (e.g. GET, PUT, POST, etc.)
 @param headers Dictionary of HTTP headers where the keys are the header names and
 the values are the header values
 
 <b>Example Usage</b>
    [[api post:@"/statuses/public_timeline.json"] success:^(ApigeeResponse *response) {
        // handle success
    } failure:^(ApigeeResponse *response) {
        // handle failure
    }];
 */
- (void)call:(NSString *)path verb:(NSString *)verb headers:(NSDictionary *)headers completion:(APGResponseBlock)completionBlock;

/**
 Performs an HTTP request to the specified path 
 @param path Path to the resource
 @param verb The HTTP method (e.g. GET, PUT, POST, etc.)
 @param body HTTP body
 
 <b>Example Usage</b>
    [[api post:@"/statuses/public_timeline.json"] success:^(ApigeeResponse *response) {
        // handle success
    } failure:^(ApigeeResponse *response) {
        // handle failure
    }]; 
 */
- (void)call:(NSString *)path verb:(NSString *)verb body:(NSData *)body completion:(APGResponseBlock)completionBlock;

/**
 Performs an HTTP request to the specified path 
 @param path Path to the resource
 @param verb The HTTP method (e.g. GET, PUT, POST, etc.)
 @param headers Dictionary of HTTP headers where the keys are the header names and
 the values are the header values
 @param body HTTP body
 
 <b>Example Usage</b>
    [[api post:@"/statuses/public_timeline.json"] success:^(ApigeeResponse *response) {
        // handle success
    } failure:^(ApigeeResponse *response) {
        // handle failure
    }];
 */
- (void)call:(NSString *)path verb:(NSString *)verb headers:(NSDictionary *)headers body:(NSData *)body completion:(APGResponseBlock)completionBlock;

@end
