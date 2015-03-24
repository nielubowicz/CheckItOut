//
//  CIOUserManager.h
//  CheckItOut
//
//  Created by Chris Nielubowicz on 3/24/15.
//  Copyright (c) 2015 Assorted Intelligence. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const defaultPassword;

@class CIOUser;

typedef void (^CIOUserManagerCompletionBlock)(CIOUser *user);

@interface CIOUserManager : NSObject

@property (strong, nonatomic, readonly) CIOUser *currentUser;

+ (instancetype)sharedUserManager;

- (void)createUserWithEmail:(NSString *)userEmail password:(NSString *)password completion:(CIOUserManagerCompletionBlock)completionBlock;
- (void)loginUser:(CIOUser *)user password:(NSString *)password completion:(CIOUserManagerCompletionBlock)completionBlock;
- (void)retrieveLoggedInUserWithCompletion:(CIOUserManagerCompletionBlock)completionBlock;

@end
