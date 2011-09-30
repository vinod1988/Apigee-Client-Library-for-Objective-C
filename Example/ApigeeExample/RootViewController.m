//
//  RootViewController.m
//  ApigeeExample
//
//  Copyright 2011 Apigee. All rights reserved.
//

#import "RootViewController.h"
#import "JSONKit.h"

@implementation RootViewController

@synthesize tweets, profilePics, api;

#pragma mark - Utilities

- (void)alert:(NSString *)s {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:s delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

#pragma mark - API Calls

- (void)createAppUser {
    
    [self.api createAppUser:@"demo2" password:@"test2" completion:^(NSHTTPURLResponse *response, NSData *data, NSError *error) {
        
        NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"create user response: %@", responseString);
        
        if ([response statusCode] == 200) {
            
            APGUser *user = [[APGUser alloc] initWithJSONDict:[data objectFromJSONData]];
            
            // persist smart key to use later        
            [APGKeychain setString:user.smartKey forKey:@"smartKey"];
            self.api.smartKey = user.smartKey;
            
            // present oauth login view
            [self.api presentLoginForProvider:@"twitter" fromViewController:self];
            
            // app will handle custom URL from twitter login in app delegate
            
            [user release];
            
        } else {
            
            NSLog(@"create user response: %i: %@", [response statusCode], responseString);
            
        }
        
        [responseString release];
        
    }];
    
}

- (void)getTweetsFromAPI {
    
    // get the twitter home timeline
    [self.api get:@"/twitter/1/statuses/home_timeline.json" completion:^(NSHTTPURLResponse *response, NSData *data, NSError *error) {
        
        if ([response statusCode] == 200) {
            
            self.tweets = [data objectFromJSONData];
            [self.tableView reloadData];
            
        } else {
            
            [self alert:@"There was a problem loading the Twitter timeline."];
            NSLog(@"timeline request: %i %@", [response statusCode], data);
            
        }
        
        
    }];
    
}

- (void)loadTweets {
    
    self.tweets = [NSArray array];
    self.profilePics = [NSMutableArray array];
    
    // show the "Calling Twitter API..." message
    [self.tableView reloadData];
    
    self.api = [APGClient sharedAPI:@"sourcesample" username:@"demo2" password:@"test2"];
    
    NSString *smartKey = [APGKeychain stringForKey:@"smartKey"];
    
    if (smartKey) {
        
        // smartKey was persisted, so no need to get it from the API
        self.api.smartKey = smartKey;
        
        [self getTweetsFromAPI];
        
    } else {
        
        // the first time you run it, you won't have a smartKey, so you need to get it from the API
        [self.api loadMySmartKey:^(NSHTTPURLResponse *response, NSData *data, NSError *error) {
            
            if ([response statusCode] == 200) {
                
                // the API object now has a smartKey, so let's persist it
                [APGKeychain setString:self.api.smartKey forKey:@"smartKey"];
                
                // now we can get the timeline
                [self getTweetsFromAPI];
                
            } else {
                
                NSLog(@"smartKey request: %i", [response statusCode]);
                [self alert:@"There was a problem loading your smartKey."];
                
            }
            
        }];
        
    }
    
    // create user style flow
    /*
     if (smartKey) {
     
     self.api.smartKey = smartKey;
     
     // get the twitter home timeline
     [self getTweetsFromAPI];
     
     } else {
     
     [self createAppUser];
     
     }
     */
}

- (void)loadProfilePic:(NSTimer *)timer {
    NSInteger index = [timer.userInfo intValue];
    
    // get the image
    NSDictionary *tweet = [self.tweets objectAtIndex:index];
    NSURL *profileImageURL = [NSURL URLWithString:[[tweet objectForKey:@"user"] objectForKey:@"profile_image_url"]];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:profileImageURL]];
    [self.profilePics addObject:image];
    
    // reload the table row
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];    
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Twitter Timeline";
    
    // add a refresh button to the nav bar
    UIBarButtonItem *refresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(loadTweets)];
    self.navigationItem.leftBarButtonItem = refresh;
    [refresh release];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadTweets];
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return MAX(1, [self.tweets count]);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {    
    if ([self.tweets count] == 0) {
        return 416.0;
    } else {
        NSDictionary *tweet = [self.tweets objectAtIndex:indexPath.row];
        NSString *text = [tweet objectForKey:@"text"];
        CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:18.0] constrainedToSize:CGSizeMake(240.0, 90000.0)];    
        return 18.0 + MAX(60, size.height);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        cell.detailTextLabel.numberOfLines = 0;
        cell.detailTextLabel.textColor = [UIColor darkGrayColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if ([self.tweets count] == 0) {
        if (self.api.smartKey) {
            cell.textLabel.text = @"Calling Twitter API...";
            cell.detailTextLabel.text = @"";
            cell.imageView.image = nil;
            
            UIActivityIndicatorView *av = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
            [av startAnimating];
            cell.accessoryView = av;
        } else {
            cell.textLabel.text = @"";
        }
    } else {
        NSDictionary *tweet = [self.tweets objectAtIndex:indexPath.row];
        cell.textLabel.text = [[tweet objectForKey:@"user"] objectForKey:@"name"];
        cell.detailTextLabel.text = [tweet objectForKey:@"text"];
        if ([profilePics count] > indexPath.row) {
            cell.imageView.image = [profilePics objectAtIndex:indexPath.row];
        } else {
            cell.imageView.image = nil;
            [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(loadProfilePic:) userInfo:[NSNumber numberWithInt:indexPath.row] repeats:NO];
        }
        cell.accessoryView = nil;
    }    
    
    return cell;
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

- (void)dealloc {
    [tweets release];
    [profilePics release];
    [api release];
    [super dealloc];
}

@end
