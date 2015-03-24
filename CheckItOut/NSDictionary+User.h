//
//  NSDictionary+User.h
//  CheckItOut
//
//  Created by chris nielubowicz on 3/24/15.
//  Copyright (c) 2015 Assorted Intelligence. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CIOUser;

@interface NSDictionary (User)

+ (NSDictionary *)pointerObjectForUser:(CIOUser *)user;

@end
