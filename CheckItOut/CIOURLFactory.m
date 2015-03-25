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

+ (NSURL *)currentUserEndpoint
{
    static NSURL *currentUserEndpoint = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        currentUserEndpoint = [NSURL URLWithString:@"1/users/me" relativeToURL:[CIOURLFactory baseURL]];
    });
    
    return currentUserEndpoint;
}

+ (NSString *)currentUserEndpointString
{
    return [[CIOURLFactory currentUserEndpoint] absoluteString];
}

+ (NSURL *)deviceEndpoint
{
    static NSURL *deviceEndpoint = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        deviceEndpoint = [NSURL URLWithString:@"1/classes/Device" relativeToURL:[CIOURLFactory baseURL]];
    });
    
    return deviceEndpoint;
}

+ (NSString *)deviceEndpointString
{
    return [[CIOURLFactory deviceEndpoint] absoluteString];
}

+ (NSURL *)deviceEndpointForObjectIdentifier:(NSString *)objectIdentifier
{
    NSURL *specificDeviceEndpoint = [NSURL URLWithString:[[CIOURLFactory deviceEndpointString] stringByAppendingFormat:@"/%@", objectIdentifier]];
    return specificDeviceEndpoint;
}

+ (NSString *)deviceEndpointStringForObjectIdentifier:(NSString *)objectIdentifier;
{
    return [[CIOURLFactory deviceEndpointForObjectIdentifier:objectIdentifier] absoluteString];
}

@end
