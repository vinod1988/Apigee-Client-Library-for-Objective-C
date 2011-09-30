Installation
------------

1. Add Security.framework to your project

2. Copy all files in the Apigee Library folder into your project.

Usage
-----

First, you need to create an ApigeeAPI object and optionally set its smartKey.  

```ApigeeAPI *api = [ApigeeAPI sharedAPI:@"myAppName"];
api.smartKey = @"secret";
```

The smartKey will identify an app user and associate with the user's credentials on other services (such as Twitter).  The smartKey should be stored securely, so we have provided a simple wrapper around the device keychain.  If you use this, values will be stored securely.

`[ApigeeKeychain stringForKey:@"smartKey"]; // returns the value stored in "smartKey"`

`[ApigeeKeychain setString:@"secret" forKey:@"smartKey"]; // stores the value securely`

To make calls to APIs, simply use the method named for the HTTP verb you want and implement the callback blocks for success and failure.  For example:

<pre>[api get:@"/twitter/1/statuses/home_timeline.json" success:^(ApigeeRequest *request) {            

    NSLog(@"Request succeeded with response body: %@", [request responseString]);

} failure:^(ApigeeRequest *request) {

    NSLog(@"Request failed with status code %i", [request responseStatusCode]);

}];
</pre>

To present an authentication view for a user to start the OAuth dance, you can call the `presentLoginForm:fromViewController:` method on your API object.  The smartKey is required for this to work successfully:

`[api presentLoginForProvider:@"twitter" fromViewController:self];`

You also must set up a custom URL type for your app.  To do this, go to your project's info pane in XCode, click the Add button on the bottom right of the window, then choose Add URL Type.  Then set your identifier and a URL Scheme.  For example:

<pre>Identifier: com.apigee.example

URL Schemes: apigeeexample</pre>

After you do this, the callback URL for the authentication view will be your custom scheme followed by the provider type.  For example, when authenticating with Twitter using the above URL scheme, the callback URL will be `apigeeexample://twitter`.

When the user successfully authenticates, the authentication view will redirect to your custom URL and the `application:openURL:sourceApplication:annotation:` method will be called on your app delegate.  Here you should dismiss the login view and then perform any other tasks you may want to do.  For example:

<pre>- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    ApigeeAPI *api = [ApigeeAPI sharedAPI:@"sourcesample"];
    [api.loginViewController dismissModalViewControllerAnimated:YES];
    
    return YES;
}</pre>
