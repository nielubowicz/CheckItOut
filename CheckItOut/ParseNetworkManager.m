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
#import "CIOParseConstants.h"
#import "CIOUser.h"

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

- (void)createUserWithEmail:(NSString *)userEmail password:(NSString *)password done:(CIONetworkUserLoginBlock)doneBlock failure:(CIONetworkFailureBlock)failureBlock;
{
    NSDictionary *parameters = @{
                                 kCIOParseUserUsername : userEmail,
                                 kCIOParseUserEmail : userEmail,
                                 kCIOParseUserPassword : password
                                 };
    
    NSMutableURLRequest *request = [[CIOJSONRequestSerializer serializer] requestWithMethod:@"POST"
                                                                                  URLString:[CIOURLFactory userEndpointString]
                                                                                 parameters:parameters
                                                                                      error:NULL];
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    requestOperation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
        CIOUser *user = [[CIOUser alloc] initWithUsername:nil withInfo:responseObject];
        if (doneBlock) {
            doneBlock(user);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failureBlock) {
            failureBlock(operation.request, error);
        }
    }];
    
    [self.operationQueue addOperation:requestOperation];
}

- (void)loginUserWithEmail:(NSString *)userEmail password:(NSString *)password done:(CIONetworkUserLoginBlock)doneBlock failure:(CIONetworkFailureBlock)failureBlock;
{
    NSDictionary *parameters = @{
                                 kCIOParseUserEmail : userEmail,
                                 kCIOParseUserPassword : password
                                 };
    
    NSMutableURLRequest *request = [[CIOJSONRequestSerializer serializer] requestWithMethod:@"GET"
                                                                                  URLString:[CIOURLFactory loginEndpointString]
                                                                                 parameters:parameters
                                                                                      error:NULL];
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    requestOperation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        CIOUser *user = [[CIOUser alloc] initWithUsername:nil withInfo:responseObject];
        if (doneBlock) {
            doneBlock(user);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failureBlock) {
            failureBlock(operation.request, error);
        }
    }];
    
    [self.operationQueue addOperation:requestOperation];
}

- (void)retrieveUserForSessionToken:(NSString *)sessionToken done:(CIONetworkUserLoginBlock)doneBlock failure:(CIONetworkFailureBlock)failureBlock;
{
    NSMutableURLRequest *request = [[CIOJSONRequestSerializer serializer] requestWithMethod:@"GET"
                                                                                  URLString:[CIOURLFactory currentUserEndpointString]
                                                                                 parameters:nil
                                                                                      error:NULL];
    [request setValue:sessionToken forHTTPHeaderField:kCIOParseSessionTokenHeader];
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    requestOperation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        CIOUser *user = [[CIOUser alloc] initWithUsername:nil withInfo:responseObject];
        if (doneBlock) {
            doneBlock(user);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failureBlock) {
            failureBlock(operation.request, error);
        }
    }];
    
    [self.operationQueue addOperation:requestOperation];
}

@end
