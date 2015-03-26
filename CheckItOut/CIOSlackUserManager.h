//
//  CIOSlackUserManager.h
//  CheckItOut
//
//  Created by chris nielubowicz on 3/25/15.
//  Copyright (c) 2015 Assorted Intelligence. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CIOSlackUserManager : NSObject

+ (instancetype)sharedSlackManager;

- (void)requestAuthorizationForCurrentUser;
- (void)issueTokenForResponseURL:(NSURL *)response;
- (void)slackUserForUser:(NSString *)userEmail completion:(void(^)(NSString *username))completionBlock;
- (void)postMessageToUser:(NSString *)username;

@end
