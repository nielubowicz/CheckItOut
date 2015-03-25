//
//  ParseNetworkManager.h
//  CheckItOut
//
//  Created by chris nielubowicz on 3/23/15.
//  Copyright (c) 2015 Assorted Intelligence. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

@class CIOUser;
@class CIODevice;

typedef void (^CIONetworkUserLoginBlock)(CIOUser *user);
typedef void (^CIONetworkDeviceCheckoutBlock)(CIODevice *device);
typedef void (^CIONetworkDeviceAlreadyCheckedOutBlock)(CIODevice *device, CIOUser *deviceOwner);
typedef void (^CIONetworkDeviceBlock)(CIODevice *device);
typedef void (^CIONetworkDevicesAvailableBlock)(NSArray *devices);
typedef void (^CIONetworkFailureBlock)(NSURLRequest *request, NSError *error);

@interface ParseNetworkManager : AFHTTPRequestOperationManager

+ (instancetype)sharedNetworkManager;

- (void)createUserWithEmail:(NSString *)userEmail password:(NSString *)password done:(CIONetworkUserLoginBlock)doneBlock failure:(CIONetworkFailureBlock)failureBlock;
- (void)loginUserWithEmail:(NSString *)userEmail password:(NSString *)password done:(CIONetworkUserLoginBlock)doneBlock failure:(CIONetworkFailureBlock)failureBlock;
- (void)retrieveUserForSessionToken:(NSString *)sessionToken done:(CIONetworkUserLoginBlock)doneBlock failure:(CIONetworkFailureBlock)failureBlock;

- (void)checkoutDevice:(CIODevice *)device toUser:(CIOUser *)user
                  done:(CIONetworkDeviceCheckoutBlock)doneBlock
                 inUse:(CIONetworkDeviceAlreadyCheckedOutBlock)inUseBlock
               failure:(CIONetworkFailureBlock)failureBlock;

- (void)fetchListOfAvailableDevicesWithDone:(CIONetworkDevicesAvailableBlock)doneBlock failure:(CIONetworkFailureBlock)failureBlock;
- (void)fetchDeviceWithIdentifier:(NSString *)identifier done:(CIONetworkDeviceBlock)doneBlock failure:(CIONetworkFailureBlock)failureBlock;

@end
