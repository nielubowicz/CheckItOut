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
        _sessionToken = userInfo[kCIOParseUserSessionTokenKey];
        if (username == nil) {
            _username = userInfo[kCIOParseUserUsernameKey];
            _userEmail = userInfo[kCIOParseUserEmailKey];
        } else {
            _userEmail = [username copy];
            _username = [username copy];
        }
        _emailVerified = [userInfo[kCIOParseUserEmailVerifiedKey] boolValue];
    }
    
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@: email:%@", NSStringFromClass([self class]), self.userEmail];
}

#pragma mark - NSCopying methods
- (id)copyWithZone:(NSZone *)zone
{
    CIOUser *user = [[self class] allocWithZone:zone];
    user->_objectID = [_objectID copyWithZone:zone];
    user->_sessionToken = [_sessionToken copyWithZone:zone];
    user->_userEmail = [_userEmail copyWithZone:zone];
    user->_username = [_username copyWithZone:zone];
    user->_emailVerified = self.isEmailVerified;
    user->_objectID = [_objectID copyWithZone:zone];
    return user;
}

@end
