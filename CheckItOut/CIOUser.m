//
//  CIOUser.m
//  CheckItOut
//
//  Created by chris nielubowicz on 3/24/15.
//  Copyright (c) 2015 Assorted Intelligence. All rights reserved.
//

#import "CIOUser.h"

@implementation CIOUser

- (instancetype)initWithUsername:(NSString *)username withInfo:(NSDictionary *)userInfo;
{
    if (self = [super init]) {
        
        _objectID = userInfo[@"objectId"];
        _sessionToken = userInfo[@"sessionToken"];
        _userEmail = [username copy];
        _username = [username copy];
    }
    return self;
}

@end
