//
//  ApigeeLoginViewController.h
//  Apigee Client Library for Objective-C
//
//  Copyright 2011 Apigee. All rights reserved.
//

#if TARGET_OS_IPHONE

#import <UIKit/UIKit.h>

@interface APGLoginViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, retain) NSURL *url;
@property (nonatomic, retain) UIWebView *webView;

- (id)initWithURL:(NSURL *)url;

@end

#endif