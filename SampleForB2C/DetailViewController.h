//
//  DetailViewController.h
//  SampleForB2C
//
//  Created by Brandon Werner on 7/4/16.
//  Copyright © 2016 Microsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property(strong, nonatomic) id detailItem;
@property(weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
