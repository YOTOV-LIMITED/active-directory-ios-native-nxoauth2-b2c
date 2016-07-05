#import <Foundation/Foundation.h>
#import "samplesTaskItem.h"
#import "samplesPolicyData.h"
#import "SamplesApplicationData.h"


@implementation SamplesApplicationData

+(id) getInstance
{
    static SamplesApplicationData *instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"settings" ofType:@"plist"]];
        NSString* va = [dictionary objectForKey:@"fullScreen"];
        NSString* sc = [dictionary objectForKey:@"showClaims"];
        instance.fullScreen = [va boolValue];
        instance.showClaims = [sc boolValue];
        instance.token = [dictionary objectForKey:@"tokenURL"];
        instance.login = [dictionary objectForKey:@"loginURL"];
        instance.keychain = [dictionary objectForKey:@"keyChain"];
        instance.clientId = [dictionary objectForKey:@"clientId"];
        instance.authority = [dictionary objectForKey:@"authorityURL"];
        instance.resourceId = [dictionary objectForKey:@"resourceString"];
        instance.scopes = [[NSMutableArray alloc]initWithArray:[dictionary objectForKey:@"scopes"]];
        instance.additionalScopes = [dictionary objectForKey:@"additionalScopes"];
        instance.redirectUriString = [dictionary objectForKey:@"redirectUri"];
        instance.taskWebApiUrlString = [dictionary objectForKey:@"taskWebAPI"];
        instance.correlationId = [dictionary objectForKey:@"correlationId"];
        instance.faceBookSignInPolicyId = [dictionary objectForKey:@"faceBookSignInPolicyId"];
        instance.emailSignInPolicyId = [dictionary objectForKey:@"emailSignInPolicyId"];
        instance.currentPolicyId = nil;
        
    });
    
    return instance;
}

@end
