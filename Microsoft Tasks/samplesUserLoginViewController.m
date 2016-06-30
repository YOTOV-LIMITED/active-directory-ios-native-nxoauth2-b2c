//
//  samplesUserLoginViewController.m
//  Microsoft Tasks
//
//  Created by Brandon Werner on 4/20/15.
//  Copyright (c) 2015 Microsoft. All rights reserved.
//

#import "samplesUserLoginViewController.h"
#import "samplesWebAPIConnector.h"
#import "samplesUseViewController.h"
#import "samplesPolicyData.h"
#import <Foundation/Foundation.h>
#import "samplesTaskItem.h"
#import "samplesPolicyData.h"
#import "NXOAuth2.h"
#import "samplesApplicationData.h"


@interface samplesUserLoginViewController ()


@end

@implementation samplesUserLoginViewController

NSString *scopes = @"offline_access Directory.ReadWrite.All";
NSString *authURL = @"https://login.microsoftonline.com/common/oauth2/v2.0/authorize";
NSString *loginURL = @"https://login.microsoftonline.com/common/login";
NSString *bhh = @"urn:ietf:wg:oauth:2.0:oob?code=";
NSString *tokenURL = @"https://login.microsoftonline.com/common/oauth2/v2.0/token";
NSString *keychain = @"com.microsoft.azureactivedirectory.samples.graph.QuickStart";
static NSString * const kIDMOAuth2SuccessPagePrefix = @"session_state=";
NSURL *myRequestedUrl;
NSURL *myLoadedUrl;
bool loginFlow = FALSE;
bool isRequestBusy;
NSURL *authcode;


- (void)viewDidLoad {
    
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"10637393134_3be20f8467_k.jpg"]];
    
    [self.view addSubview:backgroundImage];
    [self.view sendSubviewToBack:backgroundImage];
    
    
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}/Users/brwerner/Code/OIDCAndroidLib.wiki

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)signInFBPressed:(id)sender {
    
    SamplesApplicationData* appData = [SamplesApplicationData getInstance];
    samplesPolicyData *aPolicy = [[samplesPolicyData alloc]init];
    
    
    aPolicy.policyID = appData.faceBookSignInPolicyId;
    aPolicy.policyName = @"Facebook";
    
        
        
        SamplesApplicationData* data = [SamplesApplicationData getInstance];
        
        [[NXOAuth2AccountStore sharedStore] setClientID:data.clientId
                                                 secret:nil
                                                  scope:[NSSet setWithObject:scopes]
                                       authorizationURL:[NSURL URLWithString:authURL]
                                               tokenURL:[NSURL URLWithString:tokenURL]
                                            redirectURL:[NSURL URLWithString:data.redirectUriString]
                                          keyChainGroup: keychain
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
                                                                  
                                                                  samplesUseViewController* samplesUseViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ClaimsView"];
                                                                  [self.navigationController pushViewController:samplesUseViewController animated:YES];
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


- (IBAction)signInEmailPressed:(id)sender {
    
    SamplesApplicationData* appData = [SamplesApplicationData getInstance];
    samplesPolicyData *aPolicy = [[samplesPolicyData alloc]init];
    
    
    aPolicy.policyID = appData.emailSignInPolicyId;
    aPolicy.policyName = @"Sign In";
    
    
    
    SamplesApplicationData* data = [SamplesApplicationData getInstance];
    
    [[NXOAuth2AccountStore sharedStore] setClientID:data.clientId
                                             secret:nil
                                              scope:[NSSet setWithObject:scopes]
                                   authorizationURL:[NSURL URLWithString:authURL]
                                           tokenURL:[NSURL URLWithString:tokenURL]
                                        redirectURL:[NSURL URLWithString:data.redirectUriString]
                                      keyChainGroup: keychain
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
                                                              
                                                              samplesUseViewController* samplesUseViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ClaimsView"];
                                                              [self.navigationController pushViewController:samplesUseViewController animated:YES];
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




- (IBAction)signUpEmailPressed:(id)sender {
    
    
    SamplesApplicationData* appData = [SamplesApplicationData getInstance];
    samplesPolicyData *aPolicy = [[samplesPolicyData alloc]init];
    
    
    aPolicy.policyID = appData.emailSignUpPolicyId;
    aPolicy.policyName = @"Sign Up";
    
    
    
    SamplesApplicationData* data = [SamplesApplicationData getInstance];
    
    [[NXOAuth2AccountStore sharedStore] setClientID:data.clientId
                                             secret:nil
                                              scope:[NSSet setWithObject:scopes]
                                   authorizationURL:[NSURL URLWithString:authURL]
                                           tokenURL:[NSURL URLWithString:tokenURL]
                                        redirectURL:[NSURL URLWithString:data.redirectUriString]
                                      keyChainGroup: keychain
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
                                                              
                                                              samplesUseViewController* samplesUseViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ClaimsView"];
                                                              [self.navigationController pushViewController:samplesUseViewController animated:YES];
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

}
@end
