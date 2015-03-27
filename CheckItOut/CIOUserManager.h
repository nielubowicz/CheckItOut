//
//  CIOUserManager.h
//  CheckItOut
//
//  Created by Chris Nielubowicz on 3/24/15.
//  Copyright (c) 2015 Assorted Intelligence. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CIOUser.h"

FOUNDATION_EXPORT NSString *const defaultPassword;

typedef void (^CIOUserManagerCompletionBlock)(CIOUser *user);

@interface CIOUserManager : NSObject

@property (strong, nonatomic, readonly) CIOUser *currentUser;

+ (instancetype)sharedUserManager;

- (void)createUserWithEmail:(NSString *)userEmail password:(NSString *)password completion:(CIOUserManagerCompletionBlock)completionBlock;
- (void)loginUserWithEmail:(NSString *)userEmail password:(NSString *)password completion:(CIOUserManagerCompletionBlock)completionBlock;
- (void)retrieveLoggedInUserWithCompletion:(CIOUserManagerCompletionBlock)completionBlock;
- (void)logoutCurrentUser;

@end
