//
//  NSDictionary+User.m
//  CheckItOut
//
//  Created by chris nielubowicz on 3/24/15.
//  Copyright (c) 2015 Assorted Intelligence. All rights reserved.
//

#import "NSDictionary+User.h"
#import "CIOParseConstants.h"
#import "CIOUser.h"

@implementation NSDictionary (User)

+ (NSDictionary *)pointerObjectForUser:(CIOUser *)user
{
    NSDictionary *pointer = @{
                              kCIOParseTypeKey : kCIOParsePointerType,
                              kCIOParseClassNameKey : kCIOParseClassUser,
                              kCIOParseObjectIDKey : [user objectID]
                              };
    return pointer;
}

@end