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

static const char *formatString = "Mobiquity Device System\nObjectID:%s\nDeviceIdentifier:%s\nDeviceLabel:%s";

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
    NSDictionary *deviceInfo = nil;
    if (detectionString.length >= strlen(formatString)) {
        NSScanner *scanner = [NSScanner scannerWithString:detectionString];
        [scanner scanUpToString:@"\n" intoString:NULL];
        [scanner scanUpToString:@":" intoString:NULL];
        [scanner setScanLocation:scanner.scanLocation + 1];
        NSString *deviceObjectID;
        [scanner scanUpToString:@"\n" intoString:&deviceObjectID];
        [scanner scanUpToString:@":" intoString:NULL];
        [scanner setScanLocation:scanner.scanLocation + 1];
        NSString *deviceIdentifier;
        [scanner scanUpToString:@"\n" intoString:&deviceIdentifier];
        [scanner scanUpToString:@":" intoString:NULL];
        [scanner setScanLocation:scanner.scanLocation + 1];
        NSString *deviceLabel;
        [scanner scanUpToString:@"\n" intoString:&deviceLabel];
        
        
        deviceInfo = @{
                       kCIOParseObjectIDKey : deviceObjectID,
                       kCIOParseDeviceIdentifierKey : deviceIdentifier,
                       kCIOParseDeviceLabelKey :deviceLabel,
                       };
    }
    return deviceInfo;
}

@end
