//
//  AddTaskViewController.m
//  SampleForB2C
//
//  Created by Brandon Werner on 7/26/16.
//  Copyright © 2016 Microsoft. All rights reserved.
//

#import "AddTaskViewController.h"
#import "GraphAPICaller.h"
#import "Task.h"

@interface AddTaskViewController ()

@end

@implementation AddTaskViewController

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

// In a storyboard-based application, you will often want to do a little
preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)save:(id)sender {

  if (self.taskField.text.length > 0) {

    Task *taskItem = [[Task alloc] init];
    taskItem.name = self.taskField.text;

    [GraphAPICaller
                addTask:taskItem
        completionBlock:^(bool success, NSError *error) {
          if (success)

          {
            dispatch_async(dispatch_get_main_queue(), ^{

              [self.navigationController popViewControllerAnimated:TRUE];
            });
          } else {
            UIAlertView *alertView = [[UIAlertView alloc]
                    initWithTitle:nil
                          message:[[NSString alloc]
                                      initWithFormat:@"Error : %@",
                                                     error.localizedDescription]
                         delegate:nil
                cancelButtonTitle:@"Retry"
                otherButtonTitles:@"Cancel", nil];

            [alertView setDelegate:self];

            dispatch_async(dispatch_get_main_queue(), ^{
              [alertView show];
            });
          }

        }];
  }
}
@end
