//
//  LoginViewController.m
//  SampleForB2C
//
//  Created by Brandon Werner on 7/4/16.
//  Copyright © 2016 Microsoft. All rights reserved.
//

#import "AppData.h"
#import "LoginViewController.h"
#import "MasterViewController.h"
#import "NXOAuth2.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

// Put variables here

- (void)viewDidLoad {
  [super viewDidLoad];

  // Put the code from the B2C Walkthrough here
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little
 preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)resolveUsingUIWebView:(NSURL *)URL {

  // Put the code from the B2C Walkthrough here
}

#pragma mark - UIWebViewDelegate methods
- (void)webViewDidFinishLoad:(UIWebView *)webView {
  // The webview is where all the communication happens. Slightly complicated.
}

- (void)handleOAuth2AccessResult:(NSURL *)accessResult {

  // Put the code from the B2C Walkthrough here
}

- (void)setupOAuth2AccountStore {

  // Put the code from the B2C Walkthrough here
}

- (void)requestOAuth2Access {

  // Put the code from the B2C Walkthrough here
}

@end
