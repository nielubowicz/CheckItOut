//
//  CIODevice.m
//  CheckItOut
//
//  Created by Chris Nielubowicz on 3/24/15.
//  Copyright (c) 2015 Assorted Intelligence. All rights reserved.
//

#import "CIODevice.h"
#import "CIOParseConstants.h"

@interface CIODevice ()

@property (copy, nonatomic, readwrite) NSString *objectID;
@property (copy, nonatomic, readwrite) NSString *deviceLabel;
@property (copy, nonatomic, readwrite) NSString *deviceIdentifier;
@property (copy, nonatomic, readwrite) NSString *deviceModel;

@end

@implementation CIODevice

- (instancetype)initWithDictionary:(NSDictionary *)deviceInfo
{
    if (self = [super init]) {
        _objectID = deviceInfo[kCIOParseObjectIDKey];
        _deviceLabel = deviceInfo[kCIOParseDeviceLabelKey];
        _deviceIdentifier = deviceInfo[kCIOParseDeviceIdentifierKey];
        _deviceModel = deviceInfo[kCIOParseDeviceModelKey];
        
        // TODO: get current Owner from dictionary ?? or parse elsewhere ??
    }
    return self;
}

- (BOOL)isCheckedOut
{
    return self.currentOwner != nil;
}

@end
