//
//  GraphAPICaller.m
//  SampleForB2C
//
//  Created by Brandon Werner on 7/25/16.
//  Copyright © 2016 Microsoft. All rights reserved.
//

#import "AppData.h"
#import "GraphAPICaller.h"
#import "NXOAuth2.h"
#import "Task.h"

@implementation GraphAPICaller

+ (void)getTaskList:(void (^)(NSMutableArray *, NSError *))completionBlock

{
  // Add code from the B2C Walkthrough here.
}

+ (void)addTask:(Task *)task
completionBlock:(void (^)(bool, NSError *error))completionBlock {

  // Add code from the B2C Walkthrough here.
}

+ (NSDictionary *)convertParamsToDictionary:(NSString *)task {
  NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];

  [dictionary setValue:task forKey:@"Text"];

  return dictionary;
}

@end
