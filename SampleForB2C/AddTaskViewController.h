//
//  AddTaskViewController.h
//  SampleForB2C
//
//  Created by Brandon Werner on 7/26/16.
//  Copyright © 2016 Microsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddTaskViewController : UIViewController

- (IBAction)save:(id)sender;

@property(weak, nonatomic) IBOutlet UITextField *taskField;
@end
