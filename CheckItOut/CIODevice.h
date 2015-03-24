//
//  CIODevice.h
//  CheckItOut
//
//  Created by Chris Nielubowicz on 3/24/15.
//  Copyright (c) 2015 Assorted Intelligence. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CIOUser;

@interface CIODevice : NSObject

@property (copy, nonatomic, readonly) NSString *objectID;
@property (copy, nonatomic, readonly) NSString *deviceLabel;
@property (copy, nonatomic, readonly) NSString *deviceIdentifier;
@property (copy, nonatomic, readonly) NSString *deviceModel;
@property (strong, nonatomic) CIOUser *currentOwner;

@property (assign, nonatomic, readonly) BOOL isCheckedOut;

- (instancetype)initWithDictionary:(NSDictionary *)deviceInfo;
- (instancetype)initWithDetectionString:(NSString *)detectionString;

@end
