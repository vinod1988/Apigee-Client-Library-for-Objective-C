//
//  ApigeeLoginViewController.m
//  ApigeePrototype
//
//  Copyright 2011 Apigee. All rights reserved.
//

#import "ApigeeLoginViewController.h"

@implementation ApigeeLoginViewController

@synthesize url, webView;

- (id)initWithURL:(NSURL *)urlForWebView {
    self = [super init];
    if (self) {
        self.url = urlForWebView;
        NSLog(@"\n\n\n\n\n\n\n%@\n\n\n\n\n\n", self.url);
    }
    return self;
}

- (void)dealloc {
    [url release]; url = nil;
    [webView release]; webView = nil;
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)loadView {
    [super loadView];
    self.webView = [[[UIWebView alloc] initWithFrame:CGRectZero] autorelease];
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;    
    self.view = self.webView;
    self.navigationItem.title = @"Login";
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
        return YES;
}

@end
