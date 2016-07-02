//
//  samplesUserLoginViewController.h
//  Microsoft Tasks
//
//  Created by Brandon Werner on 4/20/15.
//  Copyright (c) 2015 Microsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface samplesUserLoginViewController : UIViewController <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *loginView;

- (void)handleOAuth2AccessResult:(NSString *)accessResult;
- (void)setupOAuth2AccountStore;
- (void)requestOAuth2Access;

@end
