//
//  ParseNetworkManager.m
//  CheckItOut
//
//  Created by chris nielubowicz on 3/23/15.
//  Copyright (c) 2015 Assorted Intelligence. All rights reserved.
//

#import "ParseNetworkManager.h"
#import <AFNetworking/AFNetworking.h>
#import "CIOJSONRequestSerializer.h"
#import "CIOURLFactory.h"


@interface ParseNetworkManager ()

@property (strong,nonatomic) NSURLSession *URLsession;

@end

@implementation ParseNetworkManager

+ (instancetype)sharedNetworkManager;
{
    static ParseNetworkManager *networkManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        networkManager = [[self alloc] init];
    });
    
    return networkManager;
}

- (void)createUserWithEmail:(NSString *)userEmail password:(NSString *)password
{
    NSDictionary *parameters = @{
                                 @"username" : userEmail,
                                 @"email" : userEmail,
                                 @"password" : password
                                 };
    
    NSMutableURLRequest *request = [[CIOJSONRequestSerializer serializer] requestWithMethod:@"POST"
                                                                                  URLString:[CIOURLFactory userEndpointString]
                                                                                 parameters:parameters
                                                                                      error:NULL];
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    requestOperation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
        // TODO: save session token for later use
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%s %@", __PRETTY_FUNCTION__, error);
        
    }];
    
    [self.operationQueue addOperation:requestOperation];
}

- (void)loginUserWithEmail:(NSString *)userEmail password:(NSString *)password
{
    NSDictionary *parameters = @{
                                 @"username" : userEmail,
                                 @"password" : password
                                 };
    
    NSMutableURLRequest *request = [[CIOJSONRequestSerializer serializer] requestWithMethod:@"GET"
                                                                                  URLString:[CIOURLFactory loginEndpointString]
                                                                                 parameters:parameters
                                                                                      error:NULL];
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    requestOperation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // TODO: save session token for later use
        NSLog(@"%s %@", __PRETTY_FUNCTION__, responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%s %@", __PRETTY_FUNCTION__, error);
        
    }];
    
    [self.operationQueue addOperation:requestOperation];
}

@end
