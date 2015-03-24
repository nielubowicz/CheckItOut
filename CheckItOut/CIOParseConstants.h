//
//  CIOParseConstants.h
//  CheckItOut
//
//  Created by Chris Nielubowicz on 3/24/15.
//  Copyright (c) 2015 Assorted Intelligence. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CIOParseConstants : NSObject

#pragma mark - Parse HTTP Header Keys
FOUNDATION_EXPORT NSString *const kCIOParseSessionTokenHeader;
FOUNDATION_EXPORT NSString *const kCIOParseApplicationIDHeader;
FOUNDATION_EXPORT NSString *const kCIOParseRESTAPIKeyHeader;


#pragma mark - Parse Keys
FOUNDATION_EXPORT NSString *const kCIOParseObjectIDKey;
FOUNDATION_EXPORT NSString *const kCIOParseCreatedAtKey;
FOUNDATION_EXPORT NSString *const kCIOParseUpdatedAtKey;

#pragma mark - Parse Object Keys
FOUNDATION_EXPORT NSString *const kCIOParseTypeKey;
FOUNDATION_EXPORT NSString *const kCIOParsePointerType;
FOUNDATION_EXPORT NSString *const kCIOParseClassNameKey;
FOUNDATION_EXPORT NSString *const kCIOParseClassUser;

#pragma mark - CIOUser keys
FOUNDATION_EXPORT NSString *const kCIOParseUserUsername;
FOUNDATION_EXPORT NSString *const kCIOParseUserEmail;
FOUNDATION_EXPORT NSString *const kCIOParseUserPassword;
FOUNDATION_EXPORT NSString *const kCIOParseUserSessionToken;

#pragma mark - CIODevice keys
FOUNDATION_EXPORT NSString *const kCIOParseDeviceModelKey;
FOUNDATION_EXPORT NSString *const kCIOParseDeviceLabelKey;
FOUNDATION_EXPORT NSString *const kCIOParseDeviceIdentifierKey;
FOUNDATION_EXPORT NSString *const kCIOParseDeviceCurrentOwnerKey;

@end