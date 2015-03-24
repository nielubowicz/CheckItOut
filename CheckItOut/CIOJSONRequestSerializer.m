//
//  CIOJSONRequestSerializer.m
//  CheckItOut
//
//  Created by chris nielubowicz on 3/23/15.
//  Copyright (c) 2015 Assorted Intelligence. All rights reserved.
//

#import "CIOJSONRequestSerializer.h"

@implementation CIOJSONRequestSerializer

- (NSURLRequest *)requestBySerializingRequest:(NSURLRequest *)request withParameters:(id)parameters error:(NSError *__autoreleasing *)error
{
    static NSString *parseApplicationIdentifier = nil;
    static NSString *parseRESTAPIKey = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"apiKeys" ofType:@"plist"];
        NSDictionary *infoDictionary = [NSDictionary dictionaryWithContentsOfFile:path];
        parseApplicationIdentifier = infoDictionary[@"PARSE_APPLICATION_ID"];
        parseRESTAPIKey = infoDictionary[@"PARSE_REST_API_KEY"];
    });
    
    NSMutableURLRequest *mutableRequest = [[super requestBySerializingRequest:request withParameters:parameters error:error] mutableCopy];
    [mutableRequest setValue:parseApplicationIdentifier forKey:@"X-Parse-Application-Id"];
    [mutableRequest setValue:parseRESTAPIKey forKey:@"X-Parse-REST-API-Key"];
    
    return mutableRequest;
}

@end
