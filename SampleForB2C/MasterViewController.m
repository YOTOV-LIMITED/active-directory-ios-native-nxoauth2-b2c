//
//  MasterViewController.m
//  SampleForB2C
//
//  Created by Brandon Werner on 7/4/16.
//  Copyright © 2016 Microsoft. All rights reserved.
//

#import "AppData.h"
#import "DetailViewController.h"
#import "GraphAPICaller.h"
#import "LoginViewController.h"
#import "MasterViewController.h"
#import "NXOAuth2.h"

@interface MasterViewController ()

@property NSMutableArray *taskItems;
@property(weak, nonatomic) IBOutlet UILabel *userLabel;

@property NSMutableArray *objects;
@end

@implementation MasterViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self loadData]; // Loads the data for the table after load.

  //  Add the Refresh control that allows for reloading the app by "pulling
  //  down" with your finger.
  self.refreshControl = [[UIRefreshControl alloc] init];
  [self.refreshControl addTarget:self
                          action:@selector(refreshInvoked:forState:)
                forControlEvents:UIControlEventValueChanged];
  [self setRefreshControl:self.refreshControl];

  self.detailViewController = (DetailViewController *)[
      [self.splitViewController.viewControllers lastObject] topViewController];

  // A place to keep our tasks.
  self.taskItems = [[NSMutableArray alloc] init];

  //
  // Identity Work
  //
  // Here we check if we have any accounts in the keychain we can use without
  // prompting the user to sign-in. If we don't find any, we redirect to
  // the LoginViewController and use its WebView to sign the user in.
  //

  AppData *data = [AppData getInstance];
  NXOAuth2AccountStore *store = [NXOAuth2AccountStore sharedStore];
  NSArray *accounts = [store accountsWithAccountType:data.accountIdentifier];

  if ([accounts count] == 0) {
    LoginViewController *userSelectController =
        [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
    [self.navigationController pushViewController:userSelectController
                                         animated:YES];
  }
}

- (void)loadData {
  //
  // Identity Work
  //
  // During most refreshes and new repaints we'll want to reload the data.
  // As you can see below we do the same work of getting the accounts from
  // the account store and if one is available we use that to call our
  // task API to read data. Calling the Task API uses the access token
  // that is stored in the account.
  //

  AppData *data = [AppData getInstance];
  NXOAuth2AccountStore *store = [NXOAuth2AccountStore sharedStore];
  NSArray *accounts = [store accountsWithAccountType:data.accountIdentifier];

  if ([accounts count] > 0) {
    [GraphAPICaller getTaskList:^(NSMutableArray *tasks, NSError *error) {

      if (error != nil) {
        UIAlertView *alertView = [[UIAlertView alloc]
                initWithTitle:nil
                      message:[[NSString alloc]
                                  initWithFormat:@"%@",
                                                 error.localizedDescription]
                     delegate:nil
            cancelButtonTitle:@"Retry"
            otherButtonTitles:@"Cancel", nil];

        [alertView setDelegate:self];

        dispatch_async(dispatch_get_main_queue(), ^{
          [alertView show];
        });
      } else {
        self.taskItems = (NSMutableArray *)tasks;

        // Refresh main thread since we are async
        dispatch_async(dispatch_get_main_queue(), ^{
          [self.tableView reloadData];

        });
      }
    }];
  }
}

- (void)viewWillAppear:(BOOL)animated {
  self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
  [super viewWillAppear:animated];
}

- (void)refreshInvoked:(id)sender forState:(UIControlState)state {
  // Refresh table here...
  [self.taskItems removeAllObjects];
  [self.tableView reloadData];
  [self loadData];
  [self.refreshControl endRefreshing];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([[segue identifier] isEqualToString:@"showDetail"]) {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSDate *object = self.objects[indexPath.row];
    DetailViewController *controller = (DetailViewController *)[
        [segue destinationViewController] topViewController];
    [controller setDetailItem:object];
    controller.navigationItem.leftBarButtonItem =
        self.splitViewController.displayModeButtonItem;
    controller.navigationItem.leftItemsSupplementBackButton = YES;
  }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  // Return the number of rows in the section.
  return [self.taskItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:@"Cell"
                                      forIndexPath:indexPath];

  Task *taskItem = [self.taskItems objectAtIndex:indexPath.row];
  cell.textLabel.text = taskItem.name;

  return cell;
}

- (BOOL)tableView:(UITableView *)tableView
    canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  // Return NO if you do not want the specified item to be editable.
  return NO;
}

- (void)tableView:(UITableView *)tableView
    commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
     forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    [self.objects removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[ indexPath ]
                     withRowAnimation:UITableViewRowAnimationFade];
  } else if (editingStyle == UITableViewCellEditingStyleInsert) {
    // Create a new instance of the appropriate class, insert it into the array,
    // and add a new row to the table view.
  }
}

- (IBAction)logout:(id)sender {

  AppData *data = [AppData getInstance];
  NXOAuth2AccountStore *store = [NXOAuth2AccountStore sharedStore];
  NSArray *accounts = [store accountsWithAccountType:data.accountIdentifier];

  if ([accounts count] > 0) {

    // First we remove the account from the Keychain

    for (NXOAuth2Account *account in [[NXOAuth2AccountStore sharedStore]
             accountsWithAccountType:data.accountIdentifier]) {
      [[NXOAuth2AccountStore sharedStore] removeAccount:account];
    };

    // Next, we clear the cookies since state is also persisted there as well.

    for (NSHTTPCookie *cookie in
         [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
      if ([[cookie domain] isEqualToString:@"microsoftonline.com"]) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
      }
    }
    [[NSUserDefaults standardUserDefaults] synchronize];

    [sender setTitle:@"Log In" forState:UIControlStateNormal];
    [self loadData];

  }

  else {

    LoginViewController *userSelectController =
        [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
    [self.navigationController pushViewController:userSelectController
                                         animated:YES];
  }
}
@end
