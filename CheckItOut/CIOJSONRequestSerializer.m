//
//  CIOJSONRequestSerializer.m
//  CheckItOut
//
//  Created by chris nielubowicz on 3/23/15.
//  Copyright (c) 2015 Assorted Intelligence. All rights reserved.
//

#import "CIOJSONRequestSerializer.h"
#import "CIOAPIKeys.h"
#import "CIOParseConstants.h"

@implementation CIOJSONRequestSerializer

+ (instancetype)serializer
{
    CIOJSONRequestSerializer *serializer = [super serializer];
    [serializer setValue:ParseApplicationIdentifier forHTTPHeaderField:kCIOParseApplicationIDHeader];
    [serializer setValue:ParseRESTAPIKey forHTTPHeaderField:kCIOParseRESTAPIKeyHeader];
    
    return serializer;
}

@end
