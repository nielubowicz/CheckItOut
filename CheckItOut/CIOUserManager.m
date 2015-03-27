//
//  CIOUserManager.m
//  CheckItOut
//
//  Created by Chris Nielubowicz on 3/24/15.
//  Copyright (c) 2015 Assorted Intelligence. All rights reserved.
//

#import "CIOUserManager.h"
#import "ParseNetworkManager.h"

NSString *const defaultPassword = @"junkpassword";

@interface CIOUserManager ()

@property (strong, nonatomic, readwrite) CIOUser *currentUser;

@end

@implementation CIOUserManager

+ (instancetype)sharedUserManager
{
    static CIOUserManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[CIOUserManager alloc] init];
    });
    return sharedManager;
}

- (void)setSessionToken:(NSString *)sessionToken
{
    [[NSUserDefaults standardUserDefaults] setValue:sessionToken forKey:@"SessionToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setCurrentUser:(CIOUser *)currentUser
{
    _currentUser = currentUser;
    [self setSessionToken:_currentUser.sessionToken];
}

- (void)createUserWithEmail:(NSString *)userEmail password:(NSString *)password completion:(CIOUserManagerCompletionBlock)completionBlock;
{
    __weak typeof(self) weakSelf = self;
    [[ParseNetworkManager sharedNetworkManager] createUserWithEmail:userEmail
                                                           password:password
                                                               done:^(CIOUser *user) {
                                                                   
                                                                   __strong typeof(self)strongSelf = weakSelf;
                                                                   user.userEmail = userEmail;
                                                                   user.username = userEmail;
                                                                   strongSelf.currentUser = user;
                                                                   if (completionBlock) {
                                                                       completionBlock(user);
                                                                   }
                                                               } failure:^(NSURLRequest *request, NSError *error) {

                                                                   __strong typeof(self)strongSelf = weakSelf;
                                                                   strongSelf.currentUser = nil;
                                                                   if (completionBlock) {
                                                                       completionBlock(nil);
                                                                   }
                                                               }];
}

- (void)loginUserWithEmail:(NSString *)userEmail password:(NSString *)password completion:(CIOUserManagerCompletionBlock)completionBlock;
{
    __weak typeof(self) weakSelf = self;
    [[ParseNetworkManager sharedNetworkManager] loginUserWithEmail:userEmail
                                                          password:password
                                                              done:^(CIOUser *user) {
                                                                  
                                                                  __strong typeof(self)strongSelf = weakSelf;
                                                                  strongSelf.currentUser = user;
                                                                  if (completionBlock) {
                                                                      completionBlock(user);
                                                                  }
                                                              } failure:^(NSURLRequest *request, NSError *error) {

                                                                  __strong typeof(self)strongSelf = weakSelf;
                                                                  strongSelf.currentUser = nil;
                                                                  if (completionBlock) {
                                                                      completionBlock(nil);
                                                                  }
                                                              }];
}

- (void)retrieveLoggedInUserWithCompletion:(CIOUserManagerCompletionBlock)completionBlock;
{
    NSString *sessionToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"SessionToken"];
    if (sessionToken != nil) {
        __weak typeof(self) weakSelf = self;
        [[ParseNetworkManager sharedNetworkManager] retrieveUserForSessionToken:sessionToken
                                                                           done:^(CIOUser *user) {
                                                                               
                                                                               __strong typeof(self)strongSelf = weakSelf;
                                                                               strongSelf.currentUser = user;
                                                                               if (completionBlock) {
                                                                                   completionBlock(user);
                                                                               }
                                                                           } failure:^(NSURLRequest *request, NSError *error) {
                                                                               
                                                                               __strong typeof(self)strongSelf = weakSelf;
                                                                               strongSelf.currentUser = nil;
                                                                               if (completionBlock) {
                                                                                   completionBlock(nil);
                                                                               }
                                                                           }];
    } else {
        if (completionBlock) {
            completionBlock(nil);
        }
    }
}

- (void)logoutCurrentUser
{
    self.currentUser = nil;
}

@end
