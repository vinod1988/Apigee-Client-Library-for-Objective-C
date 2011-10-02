//
//  ApigeeLoginViewController.h
//  Apigee Client Library for Objective-C
//
//  Copyright 2011 Apigee. All rights reserved.
//

#if TARGET_OS_IPHONE

#import <UIKit/UIKit.h>

/**
 The APGLoginViewController class is a convenience class for iOS apps to display
 the OAuth login page for other providers such as Twitter.  You can show the view
 with the -(void)presentLoginForProvider:fromViewController: method in APGClient,
 or you can subclass it and present it yourself if you would like to override the
 appearance of the view.  See APGClient.m for proper setup.  Also, your iOS app
 should be configured to handle a custom URL type.  See the README or Apple documentation
 for instructions.
 This class is not available for Mac applications.
 @see APGClient
 */
@interface APGLoginViewController : UIViewController <UIWebViewDelegate>

/**
 The URL for the login page
 */
@property (nonatomic, retain) NSURL *url;

/**
 The web view for the login page
 */
@property (nonatomic, retain) UIWebView *webView;

/**
 Creates and returns an APGLoginViewController that will load the URL
 */
- (id)initWithURL:(NSURL *)url;

@end

#endif