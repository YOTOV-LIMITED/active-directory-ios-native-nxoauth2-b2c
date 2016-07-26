//
//  Task.h
//  SampleForB2C
//
//  Created by Brandon Werner on 7/25/16.
//  Copyright © 2016 Microsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Task : NSObject {
  NSString *name;
}

@property(nonatomic, copy) NSString *name;
+ (id)Task:(NSString *)task name:(NSString *)name;

@end
