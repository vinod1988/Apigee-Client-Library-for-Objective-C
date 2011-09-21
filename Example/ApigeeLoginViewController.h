//
//  ApigeeLoginViewController.h
//  ApigeePrototype
//
//  Copyright 2011 Apigee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApigeeLoginViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, retain) NSURL *url;
@property (nonatomic, retain) UIWebView *webView;

- (id)initWithURL:(NSURL *)url;

@end
