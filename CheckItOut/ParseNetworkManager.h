//
//  ParseNetworkManager.h
//  CheckItOut
//
//  Created by chris nielubowicz on 3/23/15.
//  Copyright (c) 2015 Assorted Intelligence. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

@interface ParseNetworkManager : AFHTTPRequestOperationManager

+ (instancetype)sharedNetworkManager;
- (void)createUserWithEmail:(NSString *)userEmail password:(NSString *)password;
- (void)loginUserWithEmail:(NSString *)userEmail password:(NSString *)password;

@end
