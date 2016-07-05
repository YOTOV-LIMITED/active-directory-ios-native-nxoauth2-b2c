//
//  LoginViewController.h
//  SampleForB2C
//
//  Created by Brandon Werner on 7/4/16.
//  Copyright © 2016 Microsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *loginView;

- (void)handleOAuth2AccessResult:(NSURL *)accessResult;
- (void)setupOAuth2AccountStore;
- (void)requestOAuth2Access;

@end
