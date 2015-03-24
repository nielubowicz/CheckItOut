//
//  CIOParseConstants.m
//  CheckItOut
//
//  Created by Chris Nielubowicz on 3/24/15.
//  Copyright (c) 2015 Assorted Intelligence. All rights reserved.
//

#import "CIOParseConstants.h"

@implementation CIOParseConstants

#pragma mark - Parse HTTP Header Keys
NSString *const kCIOParseSessionTokenHeader = @"X-Parse-Session-Token";
NSString *const kCIOParseApplicationIDHeader = @"X-Parse-Application-Id";
NSString *const kCIOParseRESTAPIKeyHeader = @"X-Parse-REST-API-Key";

#pragma mark - Parse Keys
NSString *const kCIOParseObjectIDKey = @"objectId";
NSString *const kCIOParseCreatedAtKey = @"createdAt";
NSString *const kCIOParseUpdatedAtKey = @"updatedAt";

#pragma mark - Parse Object Keys
NSString *const kCIOParseTypeKey = @"__type";
NSString *const kCIOParsePointerType = @"Pointer";
NSString *const kCIOParseClassNameKey = @"className";
NSString *const kCIOParseClassUser = @"_User";

#pragma mark - CIOUser keys
NSString *const kCIOParseUserUsername = @"username";
NSString *const kCIOParseUserEmail = @"email";
NSString *const kCIOParseUserPassword = @"password";
NSString *const kCIOParseUserSessionToken = @"sessionToken";

#pragma mark - CIODevice keys
NSString *const kCIOParseDeviceModelKey = @"deviceModel";
NSString *const kCIOParseDeviceLabelKey = @"deviceLabel";
NSString *const kCIOParseDeviceIdentifierKey = @"deviceIdentifier";
NSString *const kCIOParseDeviceCurrentOwnerKey = @"currentOwner";

@end
