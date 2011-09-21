//
//  RootViewController.h
//  ApigeeExample
//
//  Copyright 2011 Apigee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApigeeAPI.h"

@interface RootViewController : UITableViewController

@property (nonatomic, retain) NSArray *tweets;
@property (nonatomic, retain) NSMutableArray *profilePics;
@property (nonatomic, retain) ApigeeAPI *api;

@end
