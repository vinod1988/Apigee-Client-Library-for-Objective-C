//
//  ApigeeClient.m
//  Apigee Client Library for Objective-C
//
//  Copyright 2011 Apigee. All rights reserved.
//

#import "APGClient.h"
#import "APGRequest.h"
#import "APGFormRequest.h"
#import "APGLoginViewController.h"
#import "JSONKit.h"

@interface APGConnectionDelegate : NSObject {
    APGResponseBlock completionBlock;    
    NSHTTPURLResponse *response;
    NSData *data;
    NSError *error;
}

- (id)initWithCompletionBlock:(APGResponseBlock)completionBlock;

@end

@implementation APGConnectionDelegate

- (id)initWithCompletionBlock:(APGResponseBlock)block {
    self = [super init];
    if (self) {
        completionBlock = [block copy];
    }
    return self;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)anError {
    error = [anError copy];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)someData {
    data = [someData copy];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)aResponse {
    response = [aResponse copy];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    completionBlock(response, data, error);
}

@end


@implementation APGClient

static NSMutableDictionary *apis = nil;
static char *alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"; 

@synthesize endpoint, username, password, smartKey, loginViewController;

// adapted from http://www.chrisumbel.com/article/basic_authentication_iphone_cocoa_touch
+ (NSString *)base64Encode:(NSData *)plainText {
	int encodedLength = (((([plainText length] % 3) + [plainText length]) / 3) * 4) + 1;
	char *outputBuffer = malloc(encodedLength);
	char *inputBuffer = (char *)[plainText bytes];
	
	NSInteger i;
	NSInteger j = 0;
	int remain;
	
	for(i = 0; i < [plainText length]; i += 3) {
		remain = [plainText length] - i;
		
		outputBuffer[j++] = alphabet[(inputBuffer[i] & 0xFC) >> 2];
		outputBuffer[j++] = alphabet[((inputBuffer[i] & 0x03) << 4) | 
									 ((remain > 1) ? ((inputBuffer[i + 1] & 0xF0) >> 4): 0)];
		
		if(remain > 1)
			outputBuffer[j++] = alphabet[((inputBuffer[i + 1] & 0x0F) << 2)
										 | ((remain > 2) ? ((inputBuffer[i + 2] & 0xC0) >> 6) : 0)];
		else 
			outputBuffer[j++] = '=';
		
		if(remain > 2)
			outputBuffer[j++] = alphabet[inputBuffer[i + 2] & 0x3F];
		else
			outputBuffer[j++] = '=';			
	}
	
	outputBuffer[j] = 0;
    NSString *result = [NSString stringWithCString:outputBuffer encoding:NSUTF8StringEncoding];
	free(outputBuffer);
	
	return result;
}


+ (APGClient *)sharedAPI:(NSString *)appName {
    if (!apis) {
        apis = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    if (![apis objectForKey:appName]) {
        APGClient *api = [[[self alloc] init] autorelease];
        api.endpoint = [NSString stringWithFormat:@"https://%@-api.apigee.com/v1", appName];
        [apis setObject:api forKey:appName];
    }
    return [apis objectForKey:appName];
}

+ (APGClient *)sharedAPI:(NSString *)appName username:(NSString *)username password:(NSString *)password {
    APGClient *api = [self sharedAPI:appName];
    api.username = username;
    api.password = password;
    return api;
}

- (NSMutableURLRequest *)request:(NSString *)path verb:(NSString *)verb {
    return [self request:path verb:verb headers:nil body:nil];
}

- (NSMutableURLRequest *)request:(NSString *)path verb:(NSString *)verb headers:(NSDictionary *)headers {
    return [self request:path verb:verb headers:headers body:nil];
}

- (NSMutableURLRequest *)request:(NSString *)path verb:(NSString *)verb headers:(NSDictionary *)headers body:(NSData *)body {
    NSURL *url = [self URLForPath:path];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:verb];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:body];
    
    // add basic auth header if necessary
    if (self.username && self.password) {        
        NSString *loginStr = [NSString stringWithFormat:@"%@:%@", self.username, self.password];        
        NSString *encodedLoginData = [APGClient base64Encode:[loginStr dataUsingEncoding:NSUTF8StringEncoding]];
        NSString *authHeader = [@"Basic " stringByAppendingFormat:@"%@", encodedLoginData];
        [request addValue:authHeader forHTTPHeaderField:@"Authorization"];  
    }
    
    return request;
}


- (void)loadMySmartKey:(APGResponseBlock)completionBlock {
    [self get:@"/smartkeys/me.json" completion:^(NSHTTPURLResponse *response, NSData *data, NSError *error) {
        self.smartKey = [[data objectFromJSONData] objectForKey:@"smartKey"];
        completionBlock(response, data, error);
    }];
}

- (NSURL *)authURLForProvider:(NSString *)provider callbackURL:(NSURL *)callbackURL {
    NSString *urlString = [NSString stringWithFormat:@"%@/providers/%@/authorize?smartkey=%@&app_callback=%@", self.endpoint, provider, self.smartKey, callbackURL];
    return [NSURL URLWithString:urlString];
}

#if TARGET_OS_IPHONE

- (void)presentLoginForProvider:(NSString *)provider fromViewController:(UIViewController *)fromViewController {
    
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSArray *urlTypes = [infoDict objectForKey:@"CFBundleURLTypes"];
    
    if ([urlTypes count] > 0) {
        
        NSString *scheme = [[[urlTypes objectAtIndex:0] objectForKey:@"CFBundleURLSchemes"] objectAtIndex:0];        
        NSURL *callbackURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@", scheme, provider]];
        
        self.loginViewController = [[[APGLoginViewController alloc] initWithURL:[self authURLForProvider:provider callbackURL:callbackURL]] autorelease];

        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.loginViewController];
        [fromViewController.navigationController presentModalViewController:nav animated:YES];
        [nav release];

    }
}

#endif

- (void)createAppUser:(NSString *)u password:(NSString *)p success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock {

    NSString *body = [NSString stringWithFormat:@"{ \"userName\": \"%@\", \"password\": \"%@\" }", u, p];    
    NSData *data = [body dataUsingEncoding:NSUTF8StringEncoding];

    [self post:@"/users.json" body:data success:^(APGRequest *request) {
        successBlock(request);
    } failure:^(APGRequest *request) {
        failureBlock(request);
    }];    
}

- (void)createAppUser:(NSString *)u password:(NSString *)p completion:(APGResponseBlock)completionBlock {
    
    NSString *body = [NSString stringWithFormat:@"{ \"userName\": \"%@\", \"password\": \"%@\" }", u, p];    
    NSData *data = [body dataUsingEncoding:NSUTF8StringEncoding];
    
    [self post:@"/users.json" body:data completion:^(NSHTTPURLResponse *response, NSData *data, NSError *error) {
        completionBlock(response, data, error);
    }];
}


- (void)get:(NSString *)path success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock {
    [self call:path success:successBlock failure:failureBlock];
}

- (void)get:(NSString *)path completion:(APGResponseBlock)completionBlock {
    [self call:path verb:kApgGET headers:nil body:nil completion:completionBlock];
}

- (void)get:(NSString *)path headers:(NSDictionary *)headers success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock {
    [self call:path verb:kApgGET headers:headers success:successBlock failure:failureBlock];
}

- (void)get:(NSString *)path headers:(NSDictionary *)headers completion:(APGResponseBlock)completionBlock {
    [self call:path verb:kApgGET headers:headers body:nil completion:completionBlock];
}

- (void)get:(NSString *)path headers:(NSDictionary *)headers body:(NSData *)data success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock {
    [self call:path verb:kApgGET headers:headers body:data success:successBlock failure:failureBlock];
}

- (void)get:(NSString *)path headers:(NSDictionary *)headers body:(NSData *)data completion:(APGResponseBlock)completionBlock {
    [self call:path verb:kApgGET headers:headers body:data completion:completionBlock];
}

- (void)get:(NSString *)path body:(NSData *)data success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock {
    [self call:path verb:kApgGET headers:nil body:data success:successBlock failure:failureBlock];
}

- (void)get:(NSString *)path body:(NSData *)data completion:(APGResponseBlock)completionBlock {
    [self call:path verb:kApgGET headers:nil body:data completion:completionBlock];
}

- (void)put:(NSString *)path success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock {
    [self call:path verb:kApgPUT success:successBlock failure:failureBlock];
}

- (void)put:(NSString *)path completion:(APGResponseBlock)completionBlock {
    [self call:path verb:kApgPUT headers:nil body:nil completion:completionBlock];
}

- (void)put:(NSString *)path headers:(NSDictionary *)headers success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock {
    [self call:path verb:kApgPUT headers:headers success:successBlock failure:failureBlock];
}

- (void)put:(NSString *)path headers:(NSDictionary *)headers completion:(APGResponseBlock)completionBlock {
    [self call:path verb:kApgPUT headers:headers body:nil completion:completionBlock];
}

- (void)put:(NSString *)path headers:(NSDictionary *)headers body:(NSData *)data success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock {
    [self call:path verb:kApgPUT headers:headers body:data success:successBlock failure:failureBlock];
}

- (void)put:(NSString *)path headers:(NSDictionary *)headers body:(NSData *)data completion:(APGResponseBlock)completionBlock {
    [self call:path verb:kApgPUT headers:headers body:data completion:completionBlock];
}

- (void)put:(NSString *)path body:(NSData *)data success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock {
    [self call:path verb:kApgPUT headers:nil body:data success:successBlock failure:failureBlock];
}

- (void)put:(NSString *)path body:(NSData *)data completion:(APGResponseBlock)completionBlock {
    [self call:path verb:kApgPUT headers:nil body:data completion:completionBlock];
}

- (void)post:(NSString *)path success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock {
    [self call:path verb:kApgPOST success:successBlock failure:failureBlock];
}

- (void)post:(NSString *)path completion:(APGResponseBlock)completionBlock {
    [self call:path verb:kApgPOST headers:nil body:nil completion:completionBlock];
}

- (void)post:(NSString *)path headers:(NSDictionary *)headers success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock {
    [self call:path verb:kApgPOST headers:headers success:successBlock failure:failureBlock];
}

- (void)post:(NSString *)path headers:(NSDictionary *)headers completion:(APGResponseBlock)completionBlock {
    [self call:path verb:kApgPOST headers:headers body:nil completion:completionBlock];
}

- (void)post:(NSString *)path headers:(NSDictionary *)headers body:(NSData *)data success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock {
    [self call:path verb:kApgPOST headers:headers body:data success:successBlock failure:failureBlock];
}

- (void)post:(NSString *)path headers:(NSDictionary *)headers body:(NSData *)data completion:(APGResponseBlock)completionBlock {
    [self call:path verb:kApgPOST headers:headers body:data completion:completionBlock];
}

- (void)post:(NSString *)path headers:(NSDictionary *)headers postParams:(NSDictionary *)postParams success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock {
    [self call:path verb:kApgPOST headers:headers postParams:postParams success:successBlock failure:failureBlock];
}

- (void)post:(NSString *)path body:(NSData *)data success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock {
    [self call:path verb:kApgPOST headers:nil body:data success:successBlock failure:failureBlock];
}

- (void)post:(NSString *)path body:(NSData *)data completion:(APGResponseBlock)completionBlock {
    [self call:path verb:kApgPOST headers:nil body:data completion:completionBlock];
}

- (void)post:(NSString *)path postParams:(NSDictionary *)postParams success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock {
    [self call:path verb:kApgPOST headers:nil postParams:postParams success:successBlock failure:failureBlock];
}

- (void)delete:(NSString *)path success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock {
    [self call:path verb:kApgDELETE success:successBlock failure:failureBlock];    
}

- (void)delete:(NSString *)path completion:(APGResponseBlock)completionBlock {
    [self call:path verb:kApgDELETE headers:nil body:nil completion:completionBlock];
}

- (void)delete:(NSString *)path headers:(NSDictionary *)headers success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock {
    [self call:path verb:kApgDELETE headers:headers success:successBlock failure:failureBlock];
}

- (void)delete:(NSString *)path headers:(NSDictionary *)headers completion:(APGResponseBlock)completionBlock {
    [self call:path verb:kApgDELETE headers:headers body:nil completion:completionBlock];
}

- (void)delete:(NSString *)path headers:(NSDictionary *)headers body:(NSData *)data success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock {
    [self call:path verb:kApgDELETE headers:headers body:data success:successBlock failure:failureBlock];
}

- (void)delete:(NSString *)path headers:(NSDictionary *)headers body:(NSData *)data completion:(APGResponseBlock)completionBlock {
    [self call:path verb:kApgDELETE headers:headers body:data completion:completionBlock];
}

- (void)delete:(NSString *)path body:(NSData *)data success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock {
    [self call:path verb:kApgDELETE headers:nil body:data success:successBlock failure:failureBlock];
}

- (void)delete:(NSString *)path body:(NSData *)data completion:(APGResponseBlock)completionBlock {
    [self call:path verb:kApgDELETE headers:nil body:data completion:completionBlock];
}

- (void)head:(NSString *)path success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock {
    [self call:path verb:kApgHEAD success:successBlock failure:failureBlock];
}

- (void)head:(NSString *)path completion:(APGResponseBlock)completionBlock {
    [self call:path verb:kApgHEAD headers:nil body:nil completion:completionBlock];
}

- (void)head:(NSString *)path headers:(NSDictionary *)headers success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock {
    [self call:path verb:kApgHEAD headers:headers success:successBlock failure:failureBlock];
}

- (void)head:(NSString *)path headers:(NSDictionary *)headers completion:(APGResponseBlock)completionBlock {
    [self call:path verb:kApgHEAD headers:headers body:nil completion:completionBlock];
}

- (void)head:(NSString *)path headers:(NSDictionary *)headers body:(NSData *)data success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock {
    [self call:path verb:kApgHEAD headers:headers body:data success:successBlock failure:failureBlock];
}

- (void)head:(NSString *)path headers:(NSDictionary *)headers body:(NSData *)data completion:(APGResponseBlock)completionBlock {
    [self call:path verb:kApgHEAD headers:headers body:data completion:completionBlock];
}

- (void)head:(NSString *)path body:(NSData *)data success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock {
    [self call:path verb:kApgHEAD headers:nil body:data success:successBlock failure:failureBlock];
}

- (void)head:(NSString *)path body:(NSData *)data completion:(APGResponseBlock)completionBlock {
    [self call:path verb:kApgHEAD headers:nil body:data completion:completionBlock];
}

- (void)call:(NSString *)path success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock {
    [self call:path verb:kApgGET headers:nil body:nil success:successBlock failure:failureBlock];
}

- (void)call:(NSString *)path completion:(APGResponseBlock)completionBlock {
    [self call:path verb:kApgGET headers:nil body:nil completion:completionBlock];
}

- (void)call:(NSString *)path verb:(NSString *)verb success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock {
    [self call:path verb:verb headers:nil body:nil success:successBlock failure:failureBlock];
}

- (void)call:(NSString *)path verb:(NSString *)verb completion:(APGResponseBlock)completionBlock {
    [self call:path verb:verb headers:nil body:nil completion:completionBlock];
}

- (void)call:(NSString *)path verb:(NSString *)verb headers:(NSDictionary *)headers success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock {
    [self call:path verb:verb headers:headers body:nil success:successBlock failure:failureBlock];
}

- (void)call:(NSString *)path verb:(NSString *)verb headers:(NSDictionary *)headers completion:(APGResponseBlock)completionBlock {
    [self call:path verb:verb headers:headers body:nil completion:completionBlock];
}

- (void)call:(NSString *)path verb:(NSString *)verb headers:(NSDictionary *)headers postParams:(NSDictionary *)postParams success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock {
    [self call:path verb:verb headers:headers postParams:postParams success:successBlock failure:failureBlock];
}

- (void)call:(NSString *)path verb:(NSString *)verb postParams:(NSDictionary *)postParams success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock {
    [self call:path verb:verb headers:nil postParams:postParams success:successBlock failure:failureBlock];
}

- (void)call:(NSString *)path verb:(NSString *)verb body:(NSData *)body success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock {
    [self call:path verb:verb headers:nil body:body success:successBlock failure:failureBlock];
}

- (void)call:(NSString *)path verb:(NSString *)verb body:(NSData *)body completion:(APGResponseBlock)completionBlock {
    [self call:path verb:verb headers:nil body:body completion:completionBlock];
}

- (NSURL *)URLForPath:(NSString *)path {
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
    return url;
}

- (void)call:(NSString *)path verb:(NSString *)verb headers:(NSDictionary *)headers body:(NSData *)body success:(ApigeeRequestBlock)successBlock failure:(ApigeeRequestBlock)failureBlock {
    NSURL *url = [self URLForPath:path];
    __block APGRequest *request = [APGRequest request:url verb:verb headers:headers body:body];
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

- (void)call:(NSString *)path verb:(NSString *)verb headers:(NSDictionary *)headers body:(NSData *)body completion:(APGResponseBlock)completionBlock {
    
    NSMutableURLRequest *request = [self request:path verb:verb headers:headers body:body];    
    APGConnectionDelegate *delegate = [[[APGConnectionDelegate alloc] initWithCompletionBlock:completionBlock] autorelease];
    
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:delegate];
    [connection start];
}

- (void)dealloc {
    [endpoint release]; endpoint = nil;
    [username release]; username = nil;
    [password release]; password = nil;
    [smartKey release]; smartKey = nil;
    [loginViewController release]; loginViewController = nil;
    [super dealloc];
}

@end
