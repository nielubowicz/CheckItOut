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
@property (copy, nonatomic, readwrite) NSString *deviceOperatingSystem;
@property (copy, nonatomic, readwrite) NSDate *lastCheckout;

@end

@implementation CIODevice

+ (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *_dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        _dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
        [_dateFormatter setDateFormat:kCIOParseDateFormatString];
    });
    
    return _dateFormatter;
}

- (instancetype)initWithDictionary:(NSDictionary *)deviceInfo
{
    if (self = [super init]) {
        _objectID = deviceInfo[kCIOParseObjectIDKey];
        _deviceLabel = deviceInfo[kCIOParseDeviceLabelKey];
        _deviceIdentifier = deviceInfo[kCIOParseDeviceIdentifierKey];
        _deviceModel = deviceInfo[kCIOParseDeviceModelKey];
        _deviceOperatingSystem = deviceInfo[kCIOParseDeviceOSKey];
        _lastCheckout = [[[self class] dateFormatter] dateFromString:deviceInfo[kCIOParseUpdatedAtKey]];

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
    return [NSString stringWithFormat:@"%@: (objectId:%@, deviceID:%@) Model:%@ running %@ - Label:%@",
            NSStringFromClass([self class]),
            self.objectID, self.deviceIdentifier, self.deviceModel,
            self.deviceOperatingSystem, self.deviceLabel];
}

+ (NSDictionary *)dictionaryFromDetectionString:(NSString *)detectionString
{
    NSDictionary *deviceInfo = @{
                                 kCIOParseObjectIDKey : detectionString,
                                 };
    return deviceInfo;
}

@end
