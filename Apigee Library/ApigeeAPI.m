//
//  ApigeeClient.m
//  ApigeePrototype
//
//  Copyright 2011 Apigee. All rights reserved.
//

#import "ApigeeAPI.h"
#import "ApigeeRequest.h"
#import "ApigeeFormRequest.h"
#import "ApigeeCallback.h"
#import "ApigeeLoginViewController.h"
#import "JSONKit.h"


@implementation ApigeeAPI

static NSMutableDictionary *apis = nil;

@synthesize urlObservers, endpoint, username, password, smartKey, loginViewController;

+ (ApigeeAPI *)sharedAPI:(NSString *)appName {
    if (!apis) {
        apis = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    if (![apis objectForKey:appName]) {
        ApigeeAPI *api = [[[self alloc] init] autorelease];
        api.endpoint = [NSString stringWithFormat:@"https://%@-api.apigee.com/v1", appName];
        [apis setObject:api forKey:appName];
    }
    return [apis objectForKey:appName];
}

+ (ApigeeAPI *)sharedAPI:(NSString *)appName username:(NSString *)username password:(NSString *)password {
    ApigeeAPI *api = [self sharedAPI:appName];
    api.username = username;
    api.password = password;
    return api;
}

- (id)init {
    if ((self = [super init])) {
        self.urlObservers = [NSMutableDictionary dictionary];
    }
    return self;
}

- (id)initWithOAuthOptions:(NSDictionary *)options {
    if ((self = [super init])) {
        oauthOptions = [options retain];
    }
    return self;
}

- (void)loadMySmartKey:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock {
    [self get:@"/smartkeys/me.json" success:^(ApigeeRequest *request) {
        self.smartKey = [[[request responseString] objectFromJSONString] objectForKey:@"smartKey"];
        successBlock(request);
    } failure:^(ApigeeRequest *request) {
        failureBlock(request);
    }];    
}

- (NSURL *)authURLForProvider:(NSString *)provider callbackURL:(NSURL *)callbackURL {
    NSString *urlString = [NSString stringWithFormat:@"%@/providers/%@/authorize?smartkey=%@&app_callback=%@", self.endpoint, provider, self.smartKey, callbackURL];
    return [NSURL URLWithString:urlString];
}

- (void)presentLoginForProvider:(NSString *)provider fromViewController:(UIViewController *)fromViewController {
    
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSArray *urlTypes = [infoDict objectForKey:@"CFBundleURLTypes"];
    
    if ([urlTypes count] > 0) {
        
        NSString *scheme = [[[urlTypes objectAtIndex:0] objectForKey:@"CFBundleURLSchemes"] objectAtIndex:0];        
        NSURL *callbackURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@", scheme, provider]];
        
        self.loginViewController = [[[ApigeeLoginViewController alloc] initWithURL:[self authURLForProvider:provider callbackURL:callbackURL]] autorelease];

        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.loginViewController];
        [fromViewController.navigationController presentModalViewController:nav animated:YES];
        [nav release];

    }
}

- (void)createAppUser:(NSString *)u password:(NSString *)p success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock {

    NSString *body = [NSString stringWithFormat:@"{ \"userName\": \"%@\", \"password\": \"%@\" }", u, p];    
    NSLog(@"request body: %@", body);
    NSData *data = [body dataUsingEncoding:NSUTF8StringEncoding];

    [self post:@"/users.json" body:data success:^(ApigeeRequest *request) {
        // TODO: persist user
        successBlock(request);
    } failure:^(ApigeeRequest *request) {
        failureBlock(request);
    }];    
}

- (void)get:(NSString *)path success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock {
    [self call:path success:successBlock failure:failureBlock];
}

- (void)get:(NSString *)path headers:(NSDictionary *)headers success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock {
    [self call:path verb:@"GET" headers:headers success:successBlock failure:failureBlock];
}

- (void)get:(NSString *)path headers:(NSDictionary *)headers body:(NSData *)data success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock {
    [self call:path verb:@"GET" headers:headers body:data success:successBlock failure:failureBlock];
}

- (void)get:(NSString *)path body:(NSData *)data success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock {
    [self call:path verb:@"GET" headers:nil body:data success:successBlock failure:failureBlock];
}

- (void)put:(NSString *)path success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock {
    [self call:path verb:@"PUT" success:successBlock failure:failureBlock];
}

- (void)put:(NSString *)path headers:(NSDictionary *)headers success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock {
    [self call:path verb:@"PUT" headers:headers success:successBlock failure:failureBlock];
}

- (void)put:(NSString *)path headers:(NSDictionary *)headers body:(NSData *)data success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock {
    [self call:path verb:@"PUT" headers:headers body:data success:successBlock failure:failureBlock];
}

- (void)put:(NSString *)path body:(NSData *)data success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock {
    [self call:path verb:@"PUT" headers:nil body:data success:successBlock failure:failureBlock];
}

- (void)post:(NSString *)path success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock {
    [self call:path verb:@"POST" success:successBlock failure:failureBlock];
}

- (void)post:(NSString *)path headers:(NSDictionary *)headers success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock {
    [self call:path verb:@"POST" headers:headers success:successBlock failure:failureBlock];
}

- (void)post:(NSString *)path headers:(NSDictionary *)headers body:(NSData *)data success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock {
    [self call:path verb:@"POST" headers:headers body:data success:successBlock failure:failureBlock];
}

- (void)post:(NSString *)path headers:(NSDictionary *)headers postParams:(NSDictionary *)postParams success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock {
    [self call:path verb:@"POST" headers:headers postParams:postParams success:successBlock failure:failureBlock];
}

- (void)post:(NSString *)path body:(NSData *)data success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock {
    [self call:path verb:@"POST" headers:nil body:data success:successBlock failure:failureBlock];
}

- (void)post:(NSString *)path postParams:(NSDictionary *)postParams success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock {
    [self call:path verb:@"POST" headers:nil postParams:postParams success:successBlock failure:failureBlock];
}

- (void)delete:(NSString *)path success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock {
    [self call:path verb:@"DELETE" success:successBlock failure:failureBlock];
}

- (void)delete:(NSString *)path headers:(NSDictionary *)headers success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock {
    [self call:path verb:@"DELETE" headers:headers success:successBlock failure:failureBlock];
}

- (void)delete:(NSString *)path headers:(NSDictionary *)headers body:(NSData *)data success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock {
    [self call:path verb:@"DELETE" headers:headers body:data success:successBlock failure:failureBlock];
}

- (void)delete:(NSString *)path body:(NSData *)data success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock {
    [self call:path verb:@"DELETE" headers:nil body:data success:successBlock failure:failureBlock];
}

- (void)head:(NSString *)path success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock {
    [self call:path verb:@"HEAD" success:successBlock failure:failureBlock];
}

- (void)head:(NSString *)path headers:(NSDictionary *)headers success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock {
    [self call:path verb:@"HEAD" headers:headers success:successBlock failure:failureBlock];
}

- (void)head:(NSString *)path headers:(NSDictionary *)headers body:(NSData *)data success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock {
    [self call:path verb:@"HEAD" headers:headers body:data success:successBlock failure:failureBlock];
}

- (void)head:(NSString *)path body:(NSData *)data success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock {
    [self call:path verb:@"HEAD" headers:nil body:data success:successBlock failure:failureBlock];
}

- (void)call:(NSString *)path success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock {
    [self call:path verb:@"GET" headers:nil body:nil success:successBlock failure:failureBlock];
}

- (void)call:(NSString *)path verb:(NSString *)verb success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock {
    [self call:path verb:verb headers:nil body:nil success:successBlock failure:failureBlock];
}

- (void)call:(NSString *)path verb:(NSString *)verb headers:(NSDictionary *)headers success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock {
    [self call:path verb:verb headers:headers body:nil success:successBlock failure:failureBlock];
}

- (void)call:(NSString *)path verb:(NSString *)verb headers:(NSDictionary *)headers postParams:(NSDictionary *)postParams success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock {
    [self call:path verb:verb headers:headers postParams:postParams success:successBlock failure:failureBlock];
}

- (void)call:(NSString *)path verb:(NSString *)verb postParams:(NSDictionary *)postParams success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock {
    [self call:path verb:verb headers:nil postParams:postParams success:successBlock failure:failureBlock];
}

- (ApigeeCallback *)call:(NSString *)path verb:(NSString *)verb headers:(NSDictionary *)headers postParams:(NSDictionary *)postParams {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", self.endpoint, path]];
    
    if (headers == nil) {
        headers = [NSDictionary dictionary];
    }
    
    __block ApigeeFormRequest *request = [ApigeeFormRequest request:url verb:verb headers:headers];
    if (self.username) {
        [request setUsername:self.username];
    }
    if (password) {
        [request setPassword:self.password];
    }
    /*
    for (NSString *key in postParams) {
        [request addPostValue:[postParams objectForKey:key] forKey:key];
    }
    */
    ApigeeCallback *callback = [[[ApigeeCallback alloc] initWithClient:self formRequest:request] autorelease];
    request.callback = callback;
    request.delegate = self;
    for (NSString *key in postParams) {
        [request addPostValue:[postParams objectForKey:key] forKey:key];
    }
    [request startAsynchronous];
    return callback;
}

- (void)call:(NSString *)path verb:(NSString *)verb body:(NSData *)body success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock {
    return [self call:path verb:verb headers:nil body:body success:successBlock failure:failureBlock];
}

//- (void)call:(NSString *)path verb:(NSString *)verb headers:(NSDictionary *)headers body:(NSData *)body {    
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", self.endpoint, path]];
//    NSLog(@"url: %@", url);
//    __block ApigeeRequest *request = [ApigeeRequest request:url verb:verb headers:headers body:body];
//    if (username) {
//        [request setUsername:self.username];
//    }
//    if (password) {
//        [request setPassword:self.password];
//    } 
//    ApigeeCallback *callback = [[[ApigeeCallback alloc] initWithClient:self request:request] autorelease];
//    request.callback = callback;
//    request.delegate = self;
//    request.requestMethod = verb;
//    [request startAsynchronous];
//    return callback;
//}
//

- (NSURL *)urlForPath:(NSString *)path {
    NSString *urlString;
    if (self.smartKey) {
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:[NSRegularExpression escapedPatternForString:@"?"] options:NSRegularExpressionCaseInsensitive error:nil];
        NSInteger matches = [regex numberOfMatchesInString:path options:0 range:NSMakeRange(0, [path length])];
        
        if (matches > 0) {
            urlString = [NSString stringWithFormat:@"%@%@&smartkey=%@", self.endpoint, path, self.smartKey];        
        } else {
            urlString = [NSString stringWithFormat:@"%@%@?smartkey=%@", self.endpoint, path, self.smartKey];        
        }
    } else {
        urlString = [NSString stringWithFormat:@"%@%@", self.endpoint, path];
    }
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSLog(@"url: %@", url);
    return url;
}

- (void)call:(NSString *)path verb:(NSString *)verb headers:(NSDictionary *)headers body:(NSData *)body success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock {
    NSURL *url = [self urlForPath:path];
    __block ApigeeRequest *request = [ApigeeRequest request:url verb:verb headers:headers body:body];
    NSLog(@"%@: %@ %@", url, self.username, self.password);
    if (self.username) {
        [request setUsername:self.username];
    }
    if (self.password) {
        [request setPassword:self.password];
    }
    request.delegate = self;
    request.requestMethod = verb;
    [request setCompletionBlock:^{
        if ([request isSuccess]) {
            successBlock(request);
        } else {
            failureBlock(request);
        }
    }];
    [request setFailedBlock:^{
        failureBlock(request);
    }];    
    [request startAsynchronous];
}

- (void)dealloc {
    [oauthOptions release]; oauthOptions = nil;
    [urlObservers release]; urlObservers = nil;
    [endpoint release]; endpoint = nil;
    [username release]; username = nil;
    [password release]; password = nil;
    [smartKey release]; smartKey = nil;
    [loginViewController release]; loginViewController = nil;
    [super dealloc];
}

@end
