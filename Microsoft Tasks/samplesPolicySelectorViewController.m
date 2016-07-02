//
//  samplesPolicySelectorViewController.m
//  Microsoft Tasks for Consumers
//
//  Created by Brandon Werner on 7/1/16.
//  Copyright © 2016 Microsoft. All rights reserved.
//

#import "samplesPolicySelectorViewController.h"
#import "samplesUserLoginViewController.h"
#import "samplesWebAPIConnector.h"
#import "samplesUseViewController.h"
#import "samplesPolicyData.h"
#import <Foundation/Foundation.h>
#import "samplesTaskItem.h"
#import "samplesPolicyData.h"
#import "NXOAuth2.h"
#import "samplesApplicationData.h"
@interface samplesPolicySelectorViewController ()

@end

@implementation samplesPolicySelectorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)signInFBPressed:(id)sender {
    
    
    SamplesApplicationData* appData = [SamplesApplicationData getInstance];
    appData.currentPolicyId = appData.faceBookSignInPolicyId;
    
    dispatch_async(dispatch_get_main_queue(),^ {
        
        samplesUserLoginViewController* userLoginController = [self.storyboard instantiateViewControllerWithIdentifier:@"loginView"];
        [self.navigationController pushViewController:userLoginController animated:YES];
    });
    
    
    
    
    
   }


- (IBAction)signInEmailPressed:(id)sender {
    
    SamplesApplicationData* appData = [SamplesApplicationData getInstance];
    appData.currentPolicyId = appData.faceBookSignInPolicyId;
    
    dispatch_async(dispatch_get_main_queue(),^ {
        
        samplesUserLoginViewController* userLoginController = [self.storyboard instantiateViewControllerWithIdentifier:@"loginView"];
        [self.navigationController pushViewController:userLoginController animated:YES];
    });
   
}


@end
