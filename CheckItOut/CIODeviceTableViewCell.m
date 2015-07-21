//
//  CIODeviceTableViewCell.m
//  CheckItOut
//
//  Created by chris nielubowicz on 7/20/15.
//  Copyright (c) 2015 Assorted Intelligence. All rights reserved.
//

#import "CIODeviceTableViewCell.h"
#import "CIODevice.h"
#import "CIOUser.h"

@interface CIODeviceTableViewCell ()

@property (strong, nonatomic, readwrite) CIODevice *device;

@end

@implementation CIODeviceTableViewCell

- (void)configureForDevice:(CIODevice *)device
{
    self.device = device;
    
    self.textLabel.text = [NSString stringWithFormat:@"%@ - %@", device.deviceModel, device.deviceOperatingSystem];
    
    if (device.currentOwner != nil) {
        self.textLabel.text = [self.textLabel.text stringByAppendingFormat:@" checked out by %@", self.device.currentOwner.userEmail];
        self.detailTextLabel.text = [NSString stringWithFormat:@"for %.1f hours", [self hoursSinceCheckoutDate:device.lastCheckout]];
        [self.textLabel setTextColor:[UIColor redColor]];
    } else {
        self.detailTextLabel.text = nil;
        [self.textLabel setTextColor:[UIColor blackColor]];
    }
    
    [self.detailTextLabel setTextColor:self.textLabel.textColor];
}

- (CGFloat)hoursSinceCheckoutDate:(NSDate *)checkout
{
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:checkout];
    CGFloat hours = timeInterval / 60.0 / 60.0;
    return hours;
}

@end
