//
//  samplesWebAPIConnector.m
//  Microsoft Tasks
//
//  Created by Brandon Werner on 3/11/14.
//  Copyright (c) 2014 Microsoft. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "samplesWebAPIConnector.h"
#import "samplesTaskItem.h"
#import "samplesPolicyData.h"
#import "NXOAuth2.h"
#import "NSDictionary+UrlEncoding.h"
#import "samplesApplicationData.h"


@interface samplesWebAPIConnector ()

@property (strong) NSString *userID;


@end

@implementation samplesWebAPIConnector

static NSString * const kIDMOAuth2SuccessPagePrefix = @"session_state=";
NSURL *myRequestedUrl;
NSURL *myLoadedUrl;
bool *isRequestBusy;
NSURL *authcode;



// Set up to read Policies from CoreData
//
// TODO: Add Application Settings to CoreData as well
//

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}


+(NSString*) trimString: (NSString*) toTrim
{
    //The white characters set is cached by the system:
    NSCharacterSet* set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    return [toTrim stringByTrimmingCharactersInSet:set];
}


+(void) getTokenWithPolicy:         (BOOL) clearCache
                                    policy:(samplesPolicyData *)policy
                                    params:(NSDictionary*) params
                                    parent:(UIViewController*) parent
                                    completionBlock:(void (^) (NSNotification*, NSError* error)) completionBlock
{

SamplesApplicationData* data = [SamplesApplicationData getInstance];
    
    NSString *redirectURL = [NSString stringWithFormat:@"%@?code=", data.redirectUriString];

[[NXOAuth2AccountStore sharedStore] setClientID:data.clientId
                                         secret:nil
                                          scope:[NSSet setWithObject:data.scopes]
                               authorizationURL:[NSURL URLWithString:data.authority]
                                       tokenURL:[NSURL URLWithString:data.token]
                                    redirectURL:[NSURL URLWithString:redirectURL]
                                  keyChainGroup: data.keychain
                                 forAccountType:@"myB2CService"];

[[NSNotificationCenter defaultCenter] addObserverForName:NXOAuth2AccountStoreAccountsDidChangeNotification
                                                  object:[NXOAuth2AccountStore sharedStore]
                                                   queue:nil
                                              usingBlock:^(NSNotification *aNotification) {
                                                  if (aNotification.userInfo) {
                                                      //account added, we have access
                                                      //we can now request protected data
                                                      NSLog(@"Success!! We have an access token.");
                                                      completionBlock(aNotification.userInfo.allKeys.firstObject, nil);
                                                      
                                                  } else {
                                                      //account removed, we lost access
                                                      NSError *error = nil;
                                                      NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
                                                      [errorDetail setValue:@"Lost access token" forKey:NSLocalizedDescriptionKey];
                                                      error = [NSError errorWithDomain:@"myB2CService" code:100 userInfo:errorDetail];
                                                      completionBlock(nil, error);
                                                  }
                                              }];

[[NSNotificationCenter defaultCenter] addObserverForName:NXOAuth2AccountStoreDidFailToRequestAccessNotification
                                                  object:[NXOAuth2AccountStore sharedStore]
                                                   queue:nil
                                              usingBlock:^(NSNotification *aNotification) {
                                                  NSError *error = [aNotification.userInfo objectForKey:NXOAuth2AccountStoreErrorKey];
                                                  NSLog(@"Error!! %@", error.localizedDescription);
                                              }];
}




+(void) getTaskList:(void (^) (NSArray*, NSError*))completionBlock
             parent:(UIViewController*) parent;
{

    NSString *type = @"GET";
    NSString *policy = @"WHATEVER";
    
    [self callAPIforTask:nil withQuertyType:type forPolicy:policy completionBlock:^(NSArray* graphData, NSError* error) {
        
        if (error != nil)
        {
            completionBlock(nil, error);
        }
        else
        {
            
                    NSDictionary *keyValuePairs;
                    NSMutableArray* sampleTaskItems = [[NSMutableArray alloc]init];
                    
                    for(int i =0; i < graphData.count; i++)
                    {
                        keyValuePairs = [graphData objectAtIndex:i];
                        
                        samplesTaskItem *s = [[samplesTaskItem alloc]init];
                        s.itemName = [keyValuePairs valueForKey:@"task"];
                        
                        [sampleTaskItems addObject:s];
                    }
                    
                    completionBlock(sampleTaskItems, nil);
        }
            }];
    
}

+(void) addTask:(samplesTaskItem*)task
         parent:(UIViewController*) parent
completionBlock:(void (^) (bool, NSError* error)) completionBlock
{

    
    NSString *type = @"POST";
    NSString *policy = @"WHATEVER";
    
    [self callAPIforTask:task withQuertyType:type forPolicy:policy completionBlock:^(NSArray* graphData, NSError* error) {
                
                if (error == nil){
                    
                    completionBlock(true, nil);
                }
                else
                {
                    completionBlock(false, error);
                }
            }];
}

+(void) deleteTask:(samplesTaskItem*)task
            parent:(UIViewController*) parent
   completionBlock:(void (^) (bool, NSError* error)) completionBlock
{
    
    NSString *type = @"DELETE";
    NSString *policy = @"WHATEVER";
    
    [self callAPIforTask:task withQuertyType:type forPolicy:policy completionBlock:^(NSArray* graphData, NSError* error) {
        
                if (error == nil){
                    
                    completionBlock(true, nil);
                }
                else
                {
                    completionBlock(false, error);
                }
    }];
}


+(void) loginWithPolicy:(samplesPolicyData *)policy
         parent:(UIViewController*) parent
completionBlock:(void (^) (NSNotification* userInfo, NSError* error)) completionBlock
{

    
    NSDictionary* params = [self convertPolicyToDictionary:policy];
    

    [self getTokenWithPolicy:NO policy:policy params:params parent:parent completionBlock:^(NSNotification* userInfo, NSError* error) {
       
       if (error != nil)
        {
            completionBlock(nil, error);
        }
        
        else {
            
            completionBlock(userInfo, nil);
        }
    }];
    
}

+(void) callAPIforTask:(samplesTaskItem*)task withQuertyType:(NSString*) queryType forPolicy:(NSString*) policyType
       completionBlock:(void (^) (NSArray* graphData, NSError* error)) completionBlock
{

    
    SamplesApplicationData* data = [SamplesApplicationData getInstance];
    
    NSString *taskURL = [NSString stringWithFormat:@"%@", data.taskWebApiUrlString];
    
    NXOAuth2AccountStore *store = [NXOAuth2AccountStore sharedStore];
    
    NSDictionary* params = [self convertParamsToDictionary:policyType];
    
    NSDictionary* taskInDictionaryFormat = [self convertTaskToDictionary:task];
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:taskInDictionaryFormat options:0 error:nil];
    
    NSArray *accounts = [store accountsWithAccountType:@"myB2CService"];
    NXOAuth2Request *request = [[NXOAuth2Request alloc] initWithResource:[NSURL URLWithString:taskURL] method:queryType
                                                               parameters:params];
    
    request.account = accounts[0];
    NSMutableURLRequest *urlRequest = [[request signedURLRequest] mutableCopy];
    [urlRequest setValue:@"application/json"  forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPBody:bodyData];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:queue
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* connectionError) {
                               // Process the response
                               if (data) {
                                   NSDictionary *dataReturned = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                   NSLog(@"Graph Response was: %@", dataReturned);
                                   
                                   // We can grab the top most JSON node to get our graph data.
                                   NSArray *graphData = [dataReturned objectForKey:@"value"];
                                   
                                   
                                   completionBlock(graphData, nil);
                               }
                               else
                               {
                                   completionBlock(nil, connectionError);
                               }
                           }];
}

+(NSDictionary*) convertParamsToDictionary:(NSString*)searchString
{
    NSMutableDictionary* dictionary = [[NSMutableDictionary alloc]init];
    
    NSString *query = [NSString stringWithFormat:@"startswith(givenName, '%@')", searchString];
    
    [dictionary setValue:query forKey:@"$filter"];
    
    
    
    return dictionary;
}





// Here we have some converstion helpers that allow us to parse passed items in to dictionaries for URLEncoding later.

+(NSDictionary*) convertTaskToDictionary:(samplesTaskItem*)task
{
    NSMutableDictionary* dictionary = [[NSMutableDictionary alloc]init];
    
    if (task.itemName){
        [dictionary setValue:task.itemName forKey:@"task"];
    }
    
    return dictionary;
}

+(NSDictionary*) convertPolicyToDictionary:(samplesPolicyData*)policy
{
    NSMutableDictionary* dictionary = [[NSMutableDictionary alloc]init];

    
    if (policy.policyID){
        [dictionary setValue:policy.policyID forKey:@"p"];
       // [dictionary setValue:@"openid" forKey:@"scope"];
       // [dictionary setValue:UUID forKey:@"nonce"];
      //  [dictionary setValue:@"query" forKey:@"response_mode"];
    }
    
    return dictionary;
}

+(void) signOut
{
    NXOAuth2AccountStore *store = [NXOAuth2AccountStore sharedStore];
    NSArray *accounts = [store accountsWithAccountType:@"myB2CService"];
    [[NXOAuth2AccountStore sharedStore]  removeAccount:accounts[0]];
    
    NSHTTPCookie *cookie;
    
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        [storage deleteCookie:cookie];
    }
}

@end
