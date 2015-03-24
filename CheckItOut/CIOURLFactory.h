//
//  CIOURLFactory.h
//  CheckItOut
//
//  Created by chris nielubowicz on 3/23/15.
//  Copyright (c) 2015 Assorted Intelligence. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CIOURLFactory : NSObject

+ (NSURL *)userEndpoint;
+ (NSString *)userEndpointString;
+ (NSString *)loginEndpointString;

@end
