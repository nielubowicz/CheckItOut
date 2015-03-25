//
//  CIOUser.m
//  CheckItOut
//
//  Created by chris nielubowicz on 3/24/15.
//  Copyright (c) 2015 Assorted Intelligence. All rights reserved.
//

#import "CIOUser.h"
#import "CIOParseConstants.h"

@implementation CIOUser

- (instancetype)initWithUsername:(NSString *)username withInfo:(NSDictionary *)userInfo;
{
    if (self = [super init]) {
        _objectID = userInfo[kCIOParseObjectIDKey];
        _sessionToken = userInfo[kCIOParseUserSessionToken];
        if (username == nil) {
            _username = userInfo[kCIOParseUserUsername];
            _userEmail = userInfo[kCIOParseUserEmail];
        } else {
            _userEmail = [username copy];
            _username = [username copy];
        }
    }
    
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@: email:%@", NSStringFromClass([self class]), self.userEmail];
}

@end
