//
//  LoginViewController.m
//  SampleForB2C
//
//  Created by Brandon Werner on 7/4/16.
//  Copyright © 2016 Microsoft. All rights reserved.
//

#import "LoginViewController.h"
#import "MasterViewController.h"
#import "NXOAuth2.h"

@interface LoginViewController ()

@end

@implementation LoginViewController


NSString *clientID = @"4d9bece7-188e-40f6-9edf-5c44f3a8ae0d";
NSString *clientSecret = @"";
NSString *authURL = @"https://login.microsoftonline.com/te/kidventusb2c.onmicrosoft.com/b2c_1_facebook/oauth2/v2.0/authorize";
NSString *loginURL = @"https://login.microsoftonline.com/te/kidventusb2c.onmicrosoft.com/b2c_1_facebook/oauth2/v2.0/login";
NSString *bhh = @"https://login.microsoftonline.com/common/oauth2/nativeclient";
NSString *tokenURL = @"https://login.microsoftonline.com/te/kidventusb2c.onmicrosoft.com/b2c_1_facebook/oauth2/v2.0/token";
NSString *keychain = @"com.microsoft.azureactivedirectory.samples.graph.QuickStart";
NSString *signupPolicy = @"B2C_1_facebook";
NSString *contentType = @"application/x-www-form-urlencoded";
static NSString * const kIDMOAuth2SuccessPagePrefix = @"session_state=";
NSURL *myRequestedUrl;
NSURL *myLoadedUrl;
bool loginFlow = FALSE;
bool isRequestBusy;
NSURL *authcode;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // OAuth2 Code
    
    self.loginView.delegate = self;
    [self setupOAuth2AccountStore];
    [self requestOAuth2Access];
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024
                                                         diskCapacity:20 * 1024 * 1024
                                                             diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)resolveUsingUIWebView:(NSURL *)URL {
    
    // We get the auth token from a redirect so we need to handle that in the webview.
    
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(resolveUsingUIWebView:) withObject:URL waitUntilDone:YES];
        return;
    }
    
    NSURLRequest *hostnameURLRequest = [NSURLRequest requestWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
    isRequestBusy = YES;
    [self.loginView loadRequest:hostnameURLRequest];
    
    NSLog(@"resolveUsingUIWebView ready (status: UNKNOWN, URL: %@)", self.loginView.request.URL);
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSLog(@"webView:shouldStartLoadWithRequest: %@ (%li)", request.URL, (long)navigationType);
    
    // The webview is where all the communication happens. Slightly complicated.
    
    myLoadedUrl = [webView.request mainDocumentURL];
    NSLog(@"***Loaded url: %@", myLoadedUrl);
    
    //if the UIWebView is showing our authorization URL or consent URL, show the UIWebView control
    if ([request.URL.absoluteString rangeOfString:authURL options:NSCaseInsensitiveSearch].location != NSNotFound) {
        self.loginView.hidden = NO;
    } else if ([request.URL.absoluteString rangeOfString:loginURL options:NSCaseInsensitiveSearch].location != NSNotFound) {
        //otherwise hide the UIWebView, we've left the authorization flow
        self.loginView.hidden = NO;
    } else if ([request.URL.absoluteString rangeOfString:bhh options:NSCaseInsensitiveSearch].location != NSNotFound) {
        //otherwise hide the UIWebView, we've left the authorization flow
        self.loginView.hidden = YES;
        [[NXOAuth2AccountStore sharedStore] handleRedirectURL:request.URL];
    }
    else {
        self.loginView.hidden = NO;
        //read the Location from the UIWebView, this is how Microsoft APIs is returning the
        //authentication code and relation information. This is controlled by the redirect URL we chose to use from Microsoft APIs
        //continue the OAuth2 flow
        // [[NXOAuth2AccountStore sharedStore] handleRedirectURL:request.URL];
    }
    
    return YES;
    
}

#pragma mark - UIWebViewDelegate methods
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    // The webview is where all the communication happens. Slightly complicated.
    
    
}

- (void)handleOAuth2AccessResult:(NSURL *)accessResult {
    
    
    //parse the response for success or failure
    if (accessResult)
        //if success, complete the OAuth2 flow by handling the redirect URL and obtaining a token
    {
        [[NXOAuth2AccountStore sharedStore] handleRedirectURL:accessResult];
    } else {
        //start over
        [self requestOAuth2Access];
    }
}

- (void)setupOAuth2AccountStore {
    

    NSDictionary *customAuthenticationParameters = [NSDictionary dictionaryWithObject:signupPolicy forKey:@"p"];
    NSDictionary *customHeaders = [NSDictionary dictionaryWithObject:contentType forKey:@"Content-type"];
    
    // Azure B2C needs kNXOAuth2AccountStoreConfigurationAdditionalAuthenticationParameters for sending policy to the server,
    // therefore we use -setConfiguration:forAccountType:
    NSDictionary *B2cConfigDict = @{ kNXOAuth2AccountStoreConfigurationClientID: clientID,
                                     kNXOAuth2AccountStoreConfigurationSecret: clientSecret,
                                     kNXOAuth2AccountStoreConfigurationScope: [NSSet setWithObjects:@"openid",@"offline_access", nil],
                                     kNXOAuth2AccountStoreConfigurationAuthorizeURL: [NSURL URLWithString:authURL],
                                     kNXOAuth2AccountStoreConfigurationTokenURL: [NSURL URLWithString:tokenURL],
                                     kNXOAuth2AccountStoreConfigurationRedirectURL: [NSURL URLWithString:bhh],
                                     kNXOAuth2AccountStoreConfigurationCustomHeaderFields: customHeaders,
                                    // kNXOAuth2AccountStoreConfigurationAdditionalAuthenticationParameters:customAuthenticationParameters
                                     };

    [[NXOAuth2AccountStore sharedStore] setConfiguration:B2cConfigDict
                                          forAccountType:@"myB2CService"];
    
    
    [[NSNotificationCenter defaultCenter] addObserverForName:NXOAuth2AccountStoreAccountsDidChangeNotification
                                                      object:[NXOAuth2AccountStore sharedStore]
                                                       queue:nil
                                                  usingBlock:^(NSNotification *aNotification) {
                                                      if (aNotification.userInfo) {
                                                          //account added, we have access
                                                          //we can now request protected data
                                                          NSLog(@"Success!! We have an access token.");
                                                          dispatch_async(dispatch_get_main_queue(),^ {
                                                              
                                                              MasterViewController* masterViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"master"];
                                                              [self.navigationController pushViewController:masterViewController animated:YES];
                                                          });
                                                      } else {
                                                          //account removed, we lost access
                                                      }
                                                  }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:NXOAuth2AccountStoreDidFailToRequestAccessNotification
                                                      object:[NXOAuth2AccountStore sharedStore]
                                                       queue:nil
                                                  usingBlock:^(NSNotification *aNotification) {
                                                      NSError *error = [aNotification.userInfo objectForKey:NXOAuth2AccountStoreErrorKey];
                                                      NSLog(@"Error!! %@", error.localizedDescription);
                                                  }];
}



-(void)requestOAuth2Access {
    //in order to login to Mircosoft APIs using OAuth2 we must show an embedded browser (UIWebView)
    [[NXOAuth2AccountStore sharedStore] requestAccessToAccountWithType:@"myB2CService"
                                   withPreparedAuthorizationURLHandler:^(NSURL *preparedURL) {
                                       //navigate to the URL returned by NXOAuth2Client
                                       
                                       NSURLRequest *r = [NSURLRequest requestWithURL:preparedURL];
                                       [self.loginView loadRequest:r];
                                   }];
}


@end
