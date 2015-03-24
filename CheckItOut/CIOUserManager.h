//
//  CIOUserManager.h
//  CheckItOut
//
//  Created by Chris Nielubowicz on 3/24/15.
//  Copyright (c) 2015 Assorted Intelligence. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CIOUser;

@interface CIOUserManager : NSObject

FOUNDATION_EXPORT NSString *const defaultPassword;

+ (instancetype)sharedUserManager;

- (void)loginUser:(CIOUser *)user password:(NSString *)password completion:(void(^)(CIOUser *user))completionBlock;
- (void)retrieveUserForSessionToken:(NSString *)sessionToken completion:(void(^)(CIOUser *user))completionBlock;

@end
