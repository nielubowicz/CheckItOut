//
//  CIODevice.m
//  CheckItOut
//
//  Created by Chris Nielubowicz on 3/24/15.
//  Copyright (c) 2015 Assorted Intelligence. All rights reserved.
//

#import "CIODevice.h"
#import "CIOParseConstants.h"
#import "CIOUser.h"

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
        
        if ([deviceInfo[kCIOParseDeviceCurrentOwnerKey] isEqual:[NSNull null]] || deviceInfo[kCIOParseDeviceCurrentOwnerKey] == nil) {
            _currentOwner = nil;
        } else {
            _currentOwner = [[CIOUser alloc] initWithUsername:nil withInfo:deviceInfo[kCIOParseDeviceCurrentOwnerKey]];
        }
    }
    return self;
}

- (instancetype)initWithDetectionString:(NSString *)detectionString
{
    NSDictionary *deviceInfo = [CIODevice dictionaryFromDetectionString:detectionString];
    return [self initWithDictionary:deviceInfo];
}

- (BOOL)isCheckedOut
{
    return self.currentOwner != nil;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@: (objectId:%@, deviceID:%@) Model:%@ - Label:%@", NSStringFromClass([self class]), self.objectID, self.deviceIdentifier, self.deviceModel, self.deviceLabel];
}

+ (NSDictionary *)dictionaryFromDetectionString:(NSString *)detectionString
{
    NSDictionary *deviceInfo = @{
                                 kCIOParseObjectIDKey : detectionString,
                                 };
    return deviceInfo;
}

@end
