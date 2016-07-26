//
//  Task.m
//  SampleForB2C
//
//  Created by Brandon Werner on 7/25/16.
//  Copyright © 2016 Microsoft. All rights reserved.
//

#import "Task.h"

@implementation Task

@synthesize name;

+ (id)Task:(NSString *)task name:(NSString *)name {
  Task *newTask = [[self alloc] init];
  newTask.name = name;
  return newTask;
}

@end
