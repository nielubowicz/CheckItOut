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
    static NSURL *baseURL = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        baseURL = [NSURL URLWithString:baseParseURL];
    });
    
    return baseURL;
}

+ (NSURL *)userEndpoint
{
    static NSURL *userEndpoint = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        userEndpoint = [NSURL URLWithString:@"1/users" relativeToURL:[CIOURLFactory baseURL]];
    });
    
    return userEndpoint;
}

+ (NSString *)userEndpointString
{
    return [[CIOURLFactory userEndpoint] absoluteString];
}

+ (NSURL *)loginEndpoint
{
    static NSURL *loginEndpoint = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        loginEndpoint = [NSURL URLWithString:@"1/login" relativeToURL:[CIOURLFactory baseURL]];
    });
    
    return loginEndpoint;
}

+ (NSString *)loginEndpointString
{
    return [[CIOURLFactory loginEndpoint] absoluteString];
}

@end
