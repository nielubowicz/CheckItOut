//
//  CIOURLFactory.m
//  CheckItOut
//
//  Created by chris nielubowicz on 3/23/15.
//  Copyright (c) 2015 Assorted Intelligence. All rights reserved.
//

#import "CIOURLFactory.h"

static NSString *const baseParseURL = @"https://api.parse.com";

@implementation CIOURLFactory

+ (NSURL *)baseURL
{
    return [NSURL URLWithString:baseParseURL];
}

+ (NSURL *)userEndpoint
{
    return [NSURL URLWithString:@"1/users" relativeToURL:[CIOURLFactory baseURL]];
}

@end
