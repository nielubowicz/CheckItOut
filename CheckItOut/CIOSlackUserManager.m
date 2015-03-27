//
//  CIOSlackUserManager.m
//  CheckItOut
//
//  Created by chris nielubowicz on 3/25/15.
//  Copyright (c) 2015 Assorted Intelligence. All rights reserved.
//

#import "CIOSlackUserManager.h"
#import "CIOUserManager.h"
#import "CIOAPIKeys.h"

static NSString *const kCIOSlackUsernameKeyPath = @"name";
static NSString *const kCIOSlackUserIDKeyPath = @"id";
static NSString *const kCIOSlackUserEmailKeyPath = @"profile.email";

@interface CIOSlackUser  : NSObject

@property (copy, nonatomic) NSString *username;
@property (copy, nonatomic) NSString *userEmail;
@property (copy, nonatomic) NSString *slackUserID;

- (instancetype)initWithDictionary:(NSDictionary *)slackUserInfo;

@end

@implementation CIOSlackUser

- (instancetype)initWithDictionary:(NSDictionary *)slackUserInfo;
{
    if (self = [super init]) {
        _userEmail = [slackUserInfo valueForKeyPath:kCIOSlackUserEmailKeyPath];
        _username = [slackUserInfo valueForKeyPath:kCIOSlackUsernameKeyPath];
        _slackUserID = [slackUserInfo valueForKeyPath:kCIOSlackUserIDKeyPath];
    }
    return self;
}

@end

@interface CIOSlackUserManager ()

@property (strong, nonatomic) NSString *accessToken;
@property (copy, nonatomic) NSArray *members;

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

- (CIOSlackUser *)slackUserFromMembersWithEmail:(NSString *)email
{
    CIOSlackUser *returnedUser = nil;
    for (CIOSlackUser *user in self.members) {
        if ([user.userEmail isEqualToString:email]) {
            returnedUser = user;
            break;
        }
    }
    
    return returnedUser;
}

- (void)slackUserForUser:(NSString *)userEmail completion:(void(^)(CIOSlackUser *user))completionBlock
{
    if (self.accessToken == nil) {
        [self requestAuthorizationForCurrentUser];
    }
    
    if (self.members) {
        if (completionBlock) {
            completionBlock([self slackUserFromMembersWithEmail:userEmail]);
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
                                                     NSMutableArray *slackUserArray = [NSMutableArray array];
                                                     for (NSDictionary *slackUserInfo in jsonBlob[@"members"]) {
                                                         CIOSlackUser *user = [[CIOSlackUser alloc] initWithDictionary:slackUserInfo];
                                                         [slackUserArray addObject:user];
                                                     }
                                                     
                                                     strongSelf.members = slackUserArray;
                                                     if (completionBlock) {
                                                         completionBlock([strongSelf slackUserFromMembersWithEmail:userEmail]);
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

    [self slackUserForUser:[CIOUserManager sharedUserManager].currentUser.userEmail completion:^(CIOSlackUser *posterSlackUser) {
        [self slackUserForUser:username completion:^(CIOSlackUser *slackUser) {
            
            NSString *message = [NSString stringWithFormat:@"This message sent to you by CheckItOut, courtesy of <@%@|%@>. Return your device now or face the consequences",
                                 posterSlackUser.slackUserID,
                                 posterSlackUser.username];
            NSString *escapedMessage = [message stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *slackURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://slack.com/api/chat.postMessage?token=%@&channel=@%@&text=%@",
                                                    self.accessToken, slackUser.username, escapedMessage]];
            NSURLRequest *request = [NSURLRequest requestWithURL:slackURL];
            NSURLSession *session = [NSURLSession sharedSession];
            NSURLSessionTask *oauthTask = [session dataTaskWithRequest:request
                                                     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                         
                                                     }];
            [oauthTask resume];
        }];
    }];
}

@end
