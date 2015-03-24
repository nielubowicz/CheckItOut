//
//  CIOUser.h
//  CheckItOut
//
//  Created by chris nielubowicz on 3/24/15.
//  Copyright (c) 2015 Assorted Intelligence. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CIOUser : NSObject

@property (strong, nonatomic, readonly) NSString *objectID;
@property (strong, nonatomic, readonly) NSString *sessionToken;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *userEmail;

- (instancetype)initWithUsername:(NSString *)username withInfo:(NSDictionary *)userInfo;

@end
