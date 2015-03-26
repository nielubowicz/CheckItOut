//
//  CIOSlackUserManager.m
//  CheckItOut
//
//  Created by chris nielubowicz on 3/25/15.
//  Copyright (c) 2015 Assorted Intelligence. All rights reserved.
//

#import "CIOSlackUserManager.h"
#import "CIOAPIKeys.h"

@interface CIOSlackUserManager ()

@property (strong, nonatomic) NSString *accessToken;
@property (strong, nonatomic) NSDictionary *members;

@end

@implementation CIOSlackUserManager

static NSString *kCIOSlackAccessTokenKey = @"SlackAccessToken";

+ (instancetype)sharedSlackManager
{
    static CIOSlackUserManager *sharedSlackManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSlackManager = [[self alloc] init];
    });
    return sharedSlackManager;
}

- (void)setAccessToken:(NSString *)accessToken
{
    [[NSUserDefaults standardUserDefaults] setValue:accessToken forKey:kCIOSlackAccessTokenKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)accessToken
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:kCIOSlackAccessTokenKey];
}

- (NSString *)slackUserNameFromMembersWithEmail:(NSString *)email
{
    NSString *username = nil;
    for (NSDictionary *user in self.members) {
        if ([[user valueForKeyPath:@"profile.email"] isEqualToString:email]) {
            username = user[@"name"];
            break;
        }
    }
    
    return username;
}

- (void)slackUserForUser:(NSString *)userEmail completion:(void(^)(NSString *username))completionBlock
{
    if (self.accessToken == nil) {
        [self requestAuthorizationForCurrentUser];
    }
    
    if (self.members) {
        if (completionBlock) {
            completionBlock([self slackUserNameFromMembersWithEmail:userEmail]);
        }
    } else {
        NSURLSession *session = [NSURLSession sharedSession];
        NSURL *slackURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://slack.com/api/users.list?token=%@",self.accessToken]];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:slackURL];

        __weak typeof(self) weakSelf = self;
        NSURLSessionTask *userListTask = [session dataTaskWithRequest:request
                                                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

                                                     __strong typeof(self)strongSelf = weakSelf;
                                                     NSDictionary *jsonBlob = [NSJSONSerialization JSONObjectWithData:data
                                                                                                              options:NSJSONReadingAllowFragments
                                                                                                                error:NULL];
                                                     strongSelf.members = jsonBlob[@"members"];
                                                     if (completionBlock) {
                                                         completionBlock([strongSelf slackUserNameFromMembersWithEmail:userEmail]);
                                                     }
                                                 }];
        [userListTask resume];
    }
}

- (void)requestAuthorizationForCurrentUser
{
    if (self.accessToken == nil) {
        NSURL *slackURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://slack.com/oauth/authorize?client_id=%@&team=moball", CIOSlackClientID]];
        [[UIApplication sharedApplication] openURL:slackURL];
    }
}

- (void)issueTokenForResponseURL:(NSURL *)response
{
    NSString *parameters = response.query;
    
    NSString *token;
    NSScanner *parameterScanner = [NSScanner scannerWithString:parameters];
    [parameterScanner scanUpToString:@"code=" intoString:NULL];
    [parameterScanner scanString:@"code=" intoString:NULL];
    [parameterScanner scanUpToString:@"&" intoString:&token];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *slackURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://slack.com/api/oauth.access?client_id=%@&client_secret=%@&code=%@",CIOSlackClientID, CIOSlackClientSecret, token]];

    NSURLRequest *request = [NSURLRequest requestWithURL:slackURL];

    __weak typeof(self) weakSelf = self;
    NSURLSessionTask *oauthTask = [session dataTaskWithRequest:request
                                             completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

                                                 __strong typeof(self)strongSelf = weakSelf;
                                                 NSDictionary *jsonBlob = [NSJSONSerialization JSONObjectWithData:data
                                                                                                        options:NSJSONReadingAllowFragments
                                                                                                          error:NULL];

                                                 strongSelf.accessToken = jsonBlob[@"access_token"];
                                             }];
    [oauthTask resume];
}

- (void)postMessageToUser:(NSString *)username
{
    if (self.accessToken == nil) {
        [self requestAuthorizationForCurrentUser];
    }
    
    NSString *message = [@"This message sent to you by CheckItOut, courtesy of @cnielubowicz. Return your device now or face the consequences" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *slackURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://slack.com/api/chat.postMessage?token=%@&channel=@%@&text=%@",
                                            self.accessToken, username, message]];
    NSURLRequest *request = [NSURLRequest requestWithURL:slackURL];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *oauthTask = [session dataTaskWithRequest:request
                                             completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                 
                                             }];
    [oauthTask resume];
}

@end
