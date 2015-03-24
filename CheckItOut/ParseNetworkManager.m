//
//  ParseNetworkManager.m
//  CheckItOut
//
//  Created by chris nielubowicz on 3/23/15.
//  Copyright (c) 2015 Assorted Intelligence. All rights reserved.
//

#import "ParseNetworkManager.h"
#import <AFNetworking/AFNetworking.h>
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

- (AFURLSessionManager *)URLsession
{
    if (_URLsession == nil) {
        NSURLSessionConfiguration *urlSessionConfiguration  = [NSURLSessionConfiguration defaultSessionConfiguration];
        _URLsession = [NSURLSession sessionWithConfiguration:urlSessionConfiguration];
    }
    return _URLsession;
}

- (NSMutableURLRequest *)preparedRequestWithURL:(NSURL *)URL
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    
    return request;
}

- (void)createUserWithEmail:(NSString *)userEmail password:(NSString *)password
{
    NSURLSession *session = [self URLsession];
    NSURL *userEndpoint = [CIOURLFactory userEndpoint];
    NSMutableURLRequest *request = [self preparedRequestWithURL:userEndpoint];
    [request setHTTPMethod:@"PUT"];
    
    [[session dataTaskWithRequest:request
                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                    
                    
                }] resume];
}

- (void)loginUserWithEmail:(NSString *)userEmail password:(NSString *)password
{
    
}

@end
