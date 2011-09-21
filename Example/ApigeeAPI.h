//
//  ApigeeAPI.h
//  ApigeePrototype
//
//  Copyright 2011 Apigee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApigeeUser.h"
#import "ApigeeRequest.h"
#import "ApigeeKeychain.h"

@class ApigeeCallback, ApigeeResponse, ApigeeLoginViewController;

typedef void (^ApigeeRequestBlock)(ApigeeRequest *request);
typedef void (^ApigeeResponseBlock)(ApigeeResponse *response);


/**
 The ApigeeAPI class provides a simple way to talk to your APIs through the
 Apigee proxy.  It provides several convenience methods to create HTTP requests
 and send them.
 
 All API call methods return an ApigeeCallback object that you can use to handle
 success and failure responses.
 */
@interface ApigeeAPI : NSObject {
    NSDictionary *oauthOptions;
    ApigeeLoginViewController *loginViewController;
}

@property (nonatomic, retain) NSMutableDictionary *urlObservers;
@property (nonatomic, retain) NSString *endpoint;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *smartKey;
@property (nonatomic, retain) ApigeeLoginViewController *loginViewController;

+ (ApigeeAPI *)sharedAPI:(NSString *)appName;

/**
 Creates and returns an ApigeeAPI object for you to use to make REST API calls.
 @param endpoint Your Apigee Source URL.  Example: http://myapp.apigee.com
 @param username Your Apigee Source username
 @param password Your Apigee Source password
 @return ApigeeAPI object for you to use to make REST API calls
 
 <h4 class="method-subtitle parameter-title">Example Usage</h4>
    ApigeeAPI *api = [ApigeeAPI api:@"http://myapp.apigee.com" username:@"user" password:@"pass"];
 */
+ (ApigeeAPI *)sharedAPI:(NSString *)appName username:(NSString *)username password:(NSString *)password;

- (id)initWithOAuthOptions:(NSDictionary *)oauthOptions;

- (void)loadMySmartKey:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock;

- (NSURL *)authURLForProvider:(NSString *)provider callbackURL:(NSURL *)callbackURL;

- (void)createAppUser:(NSString *)username password:(NSString *)password success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock;

- (void)call:(NSString *)path success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock;

- (void)presentLoginForProvider:(NSString *)provider fromViewController:(UIViewController *)fromViewController;

/**
 Performs an HTTP GET request to the specified path on the Apigee Source proxy
 @param path Path to the resource.

 <b>Example Usage</b>
    [[api get:@"/statuses/public_timeline.json"] success:^(ApigeeResponse *response) {
        // handle success
    } failure:^(ApigeeResponse *response) {
        // handle failure
    }];
 */
- (void)get:(NSString *)path success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock;

/**
 Performs an HTTP GET request to the specified path on the Apigee Source proxy
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
- (void)get:(NSString *)path headers:(NSDictionary *)headers success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock;

/**
 Performs an HTTP GET request to the specified path on the Apigee Source proxy
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
- (void)get:(NSString *)path headers:(NSDictionary *)headers body:(NSData *)data success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock;

/**
 Performs an HTTP GET request to the specified path on the Apigee Source proxy
 @param path Path to the resource
 @param data HTTP body
 
 <b>Example Usage</b>
    [[api get:@"/statuses/public_timeline.json" body:body] success:^(ApigeeResponse *response) {
        // handle success
    } failure:^(ApigeeResponse *response) {
        // handle failure
    }];
 */
- (void)get:(NSString *)path body:(NSData *)data success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock;

/**
 Performs an HTTP PUT request to the specified path on the Apigee Source proxy
 @param path Path to the resource.
 
 <b>Example Usage</b>
    [[api put:@"/statuses/public_timeline.json"] success:^(ApigeeResponse *response) {
        // handle success
    } failure:^(ApigeeResponse *response) {
        // handle failure
    }];
 */
- (void)put:(NSString *)path success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock;

/**
 Performs an HTTP PUT request to the specified path on the Apigee Source proxy
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
- (void)put:(NSString *)path headers:(NSDictionary *)headers success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock;

/**
 Performs an HTTP PUT request to the specified path on the Apigee Source proxy
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
- (void)put:(NSString *)path headers:(NSDictionary *)headers body:(NSData *)data success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock;

/**
 Performs an HTTP PUT request to the specified path on the Apigee Source proxy
 @param path Path to the resource
 @param data HTTP body
 
 <b>Example Usage</b>
    [[api put:@"/statuses/public_timeline.json" body:body] success:^(ApigeeResponse *response) {
        // handle success
    } failure:^(ApigeeResponse *response) {
        // handle failure
    }];
 */
- (void)put:(NSString *)path body:(NSData *)data success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock;

/**
 Performs an HTTP POST request to the specified path on the Apigee Source proxy
 @param path Path to the resource
 
 <b>Example Usage</b>
    [[api post:@"/statuses/public_timeline.json"] success:^(ApigeeResponse *response) {
        // handle success
    } failure:^(ApigeeResponse *response) {
        // handle failure
    }];
 */
- (void)post:(NSString *)path success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock;

/**
 Performs an HTTP POST request to the specified path on the Apigee Source proxy
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
- (void)post:(NSString *)path headers:(NSDictionary *)headers success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock;

/**
 Performs an HTTP POST request to the specified path on the Apigee Source proxy
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
- (void)post:(NSString *)path headers:(NSDictionary *)headers body:(NSData *)data success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock;

/**
 Performs an HTTP POST request to the specified path on the Apigee Source proxy
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
- (void)post:(NSString *)path headers:(NSDictionary *)headers postParams:(NSDictionary *)postParams success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock;

/**
 Performs an HTTP POST request to the specified path on the Apigee Source proxy
 @param path Path to the resource
 @param data HTTP body
 
 <b>Example Usage</b>
    [[api post:@"/statuses/public_timeline.json"] success:^(ApigeeResponse *response) {
        // handle success
    } failure:^(ApigeeResponse *response) {
        // handle failure
    }];
 */
- (void)post:(NSString *)path body:(NSData *)data success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock;

/**
 Performs an HTTP POST request to the specified path on the Apigee Source proxy
 @param path Path to the resource
 @param postParams Dictionary of form data where the keys are the form fields and
 the values are the form values
 
 <b>Example Usage</b>
    [[api post:@"/statuses/public_timeline.json"] success:^(ApigeeResponse *response) {
        // handle success
    } failure:^(ApigeeResponse *response) {
        // handle failure
    }];
 */
- (void)post:(NSString *)path postParams:(NSDictionary *)postParams success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock;

/**
 Performs an HTTP DELETE request to the specified path on the Apigee Source proxy
 @param path Path to the resource
 
 <b>Example Usage</b>
    [[api post:@"/statuses/public_timeline.json"] success:^(ApigeeResponse *response) {
        // handle success
    } failure:^(ApigeeResponse *response) {
        // handle failure
    }];
 */
- (void)delete:(NSString *)path success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock;

/**
 Performs an HTTP DELETE request to the specified path on the Apigee Source proxy
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
- (void)delete:(NSString *)path headers:(NSDictionary *)headers success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock;

/**
 Performs an HTTP DELETE request to the specified path on the Apigee Source proxy
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
- (void)delete:(NSString *)path headers:(NSDictionary *)headers body:(NSData *)data success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock;

/**
 Performs an HTTP DELETE request to the specified path on the Apigee Source proxy
 @param path Path to the resource
 @param data HTTP body
 
 <b>Example Usage</b>
    [[api post:@"/statuses/public_timeline.json"] success:^(ApigeeResponse *response) {
        // handle success
    } failure:^(ApigeeResponse *response) {
        // handle failure
    }];
 */
- (void)delete:(NSString *)path body:(NSData *)data success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock;

/**
 Performs an HTTP HEAD request to the specified path on the Apigee Source proxy
 @param path Path to the resource
 
 <b>Example Usage</b>
    [[api post:@"/statuses/public_timeline.json"] success:^(ApigeeResponse *response) {
        // handle success
    } failure:^(ApigeeResponse *response) {
        // handle failure
    }];
 */
- (void)head:(NSString *)path success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock;

/**
 Performs an HTTP HEAD request to the specified path on the Apigee Source proxy
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
- (void)head:(NSString *)path headers:(NSDictionary *)headers success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock;

/**
 Performs an HTTP HEAD request to the specified path on the Apigee Source proxy
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
- (void)head:(NSString *)path headers:(NSDictionary *)headers body:(NSData *)data success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock;

/**
 Performs an HTTP HEAD request to the specified path on the Apigee Source proxy
 @param path Path to the resource
 @param data HTTP body
 
 <b>Example Usage</b>
    [[api post:@"/statuses/public_timeline.json"] success:^(ApigeeResponse *response) {
        // handle success
    } failure:^(ApigeeResponse *response) {
        // handle failure
    }];
 */
- (void)head:(NSString *)path body:(NSData *)data success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock;

/**
 Performs an HTTP request to the specified path on the Apigee Source proxy
 @param path Path to the resource
 @param verb The HTTP method (e.g. GET, PUT, POST, etc.)
 
 <b>Example Usage</b>
    [[api post:@"/statuses/public_timeline.json"] success:^(ApigeeResponse *response) {
        // handle success
    } failure:^(ApigeeResponse *response) {
        // handle failure
    }];
 */
- (void)call:(NSString *)path verb:(NSString *)verb success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock;

/**
 Performs an HTTP request to the specified path on the Apigee Source proxy
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
- (void)call:(NSString *)path verb:(NSString *)verb headers:(NSDictionary *)headers success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock;

/**
 Performs an HTTP request to the specified path on the Apigee Source proxy
 @param path Path to the resource
 @param verb The HTTP method (e.g. GET, PUT, POST, etc.)
 @param postParams Dictionary of form data where the keys are the form fields and
 the values are the form values
 
 <b>Example Usage</b>
    [[api post:@"/statuses/public_timeline.json"] success:^(ApigeeResponse *response) {
        // handle success
    } failure:^(ApigeeResponse *response) {
        // handle failure
    }];
 */
- (void)call:(NSString *)path verb:(NSString *)verb postParams:(NSDictionary *)postParams success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock;


/**
 Performs an HTTP request to the specified path on the Apigee Source proxy
 @param path Path to the resource
 @param verb The HTTP method (e.g. GET, PUT, POST, etc.)
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
- (void)call:(NSString *)path verb:(NSString *)verb headers:(NSDictionary *)headers postParams:(NSDictionary *)postParams success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock;

/**
 Performs an HTTP request to the specified path on the Apigee Source proxy
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
- (void)call:(NSString *)path verb:(NSString *)verb body:(NSData *)body success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock;

/**
 Performs an HTTP request to the specified path on the Apigee Source proxy
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
- (void)call:(NSString *)path verb:(NSString *)verb headers:(NSDictionary *)headers body:(NSData *)body success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock;

@end
