//
//  CIOUserManager.m
//  CheckItOut
//
//  Created by Chris Nielubowicz on 3/24/15.
//  Copyright (c) 2015 Assorted Intelligence. All rights reserved.
//

#import "CIOUserManager.h"
#import "ParseNetworkManager.h"
#import "CIOUser.h"

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

- (void)loginUser:(CIOUser *)user password:(NSString *)password
{
    [[ParseNetworkManager sharedNetworkManager] loginUserWithEmail:user.userEmail
                                                          password:password
                                                              done:^(CIOUser *user) {
                                                                  
                                                                  // TODO: save session token
                                                                  [[NSUserDefaults standardUserDefaults] setValue:user.sessionToken forKey:@"SessionToken"];
                                                                  
                                                              } failure:^(NSURLRequest *request, NSError *error) {
                                                                  
                                                                  [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"SessionToken"];
                                                              }];
}

- (void)retrieveUserForSessionToken:(NSString *)sessionToken
{
    [[ParseNetworkManager sharedNetworkManager] retrieveUserForSessionToken:sessionToken
                                                                       done:^(CIOUser *user) {
                                                                           
                                                                       } failure:^(NSURLRequest *request, NSError *error) {
                                                                           
                                                                           [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"SessionToken"];
                                                                       }];
}

@end
