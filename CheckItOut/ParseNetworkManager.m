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
#import "CIODevice.h"
#import "NSDictionary+User.h"
#import "CIOUserManager.h"

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

#pragma mark - User Creation and Login

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
                                 kCIOParseUserUsername : userEmail,
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

#pragma mark - Device checkout
- (void)checkoutDevice:(CIODevice *)device toUser:(CIOUser *)user
                  done:(CIONetworkDeviceCheckoutBlock)doneBlock
                 inUse:(CIONetworkDeviceAlreadyCheckedOutBlock)inUseBlock
               failure:(CIONetworkFailureBlock)failureBlock;
{
    NSMutableURLRequest *deviceStatusRequest = [[CIOJSONRequestSerializer serializer] requestWithMethod:@"GET"
                                                                                              URLString:[CIOURLFactory deviceEndpointStringForObjectIdentifier:device.objectID]
                                                                                             parameters:nil
                                                                                                  error:NULL];
    
    AFHTTPRequestOperation *deviceStatusRequestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:deviceStatusRequest];
    deviceStatusRequestOperation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [deviceStatusRequestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        CIODevice *returnedDevice = [[CIODevice alloc] initWithDictionary:responseObject];
        
        if (returnedDevice.currentOwner == nil) {
            NSLog(@"Device: %@ is not checked out. Proceeding with checkout for user: %@", returnedDevice, user);
            
            NSDictionary *userDictionary = [NSDictionary pointerObjectForUser:user];
            NSDictionary *parameters = @{
                                         kCIOParseDeviceCurrentOwnerKey : userDictionary,
                                         kCIOParseDeviceIsCheckedOutKey : @(YES)
                                         };
            NSMutableURLRequest *request = [[CIOJSONRequestSerializer serializer] requestWithMethod:@"PUT"
                                                                                          URLString:[CIOURLFactory deviceEndpointStringForObjectIdentifier:device.objectID]
                                                                                         parameters:parameters
                                                                                              error:NULL];
            
            AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
            requestOperation.responseSerializer = [AFJSONResponseSerializer serializer];
            
            [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                if (doneBlock) {
                    doneBlock(returnedDevice);
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (failureBlock) {
                    failureBlock(operation.request, error);
                }
            }];
            
            [self.operationQueue addOperation:requestOperation];
        } else {

            // compare current user to device's current owner
            CIOUser *currentUser = [CIOUserManager sharedUserManager].currentUser;
            if ([currentUser.objectID isEqualToString:returnedDevice.currentOwner.objectID]) {
                NSLog(@"Device: %@ is checked out, by you!. Proceeding with checkin, this will remove user: %@ from the device", returnedDevice, user);
                NSDictionary *parameters = @{
                                             kCIOParseDeviceCurrentOwnerKey : @{ kCIOParseOperationKey : kCIOParseOperationDelete },
                                             kCIOParseDeviceIsCheckedOutKey : @(NO)
                                             };
                
                NSMutableURLRequest *request = [[CIOJSONRequestSerializer serializer] requestWithMethod:@"PUT"
                                                                                              URLString:[CIOURLFactory deviceEndpointStringForObjectIdentifier:device.objectID]
                                                                                             parameters:parameters
                                                                                                  error:NULL];
                
                AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
                requestOperation.responseSerializer = [AFJSONResponseSerializer serializer];
                
                [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                    returnedDevice.currentOwner = nil;
                    if (doneBlock) {
                        doneBlock(returnedDevice);
                    }
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    if (failureBlock) {
                        failureBlock(operation.request, error);
                    }
                }];
                
                [self.operationQueue addOperation:requestOperation];

            } else {
                NSDictionary *parameters = @{
                                             kCIOParseObjectIDKey : returnedDevice.currentOwner.objectID
                                             };
                NSMutableURLRequest *request = [[CIOJSONRequestSerializer serializer] requestWithMethod:@"GET"
                                                                                              URLString:[CIOURLFactory userEndpointString]
                                                                                             parameters:parameters
                                                                                                  error:NULL];
                
                AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
                requestOperation.responseSerializer = [AFJSONResponseSerializer serializer];
                
                [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                    CIOUser *currentOwner = [[CIOUser alloc] initWithUsername:nil withInfo:responseObject[@"results"]];
                    NSLog(@"Device: %@ is checked out. You should go bother %@ to get the device", returnedDevice, currentOwner);
                    
                    if (inUseBlock) {
                        inUseBlock(returnedDevice, currentOwner);
                    }
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    if (failureBlock) {
                        failureBlock(operation.request, error);
                    }
                }];
                
                [self.operationQueue addOperation:requestOperation];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failureBlock) {
            failureBlock(operation.request, error);
        }
    }];
    
    [self.operationQueue addOperation:deviceStatusRequestOperation];
}

@end
