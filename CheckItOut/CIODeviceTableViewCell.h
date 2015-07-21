//
//  CIODeviceTableViewCell.h
//  CheckItOut
//
//  Created by chris nielubowicz on 7/20/15.
//  Copyright (c) 2015 Assorted Intelligence. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CIODevice;

@interface CIODeviceTableViewCell : UITableViewCell

@property (strong, nonatomic, readonly) CIODevice *device;

- (void)configureForDevice:(CIODevice *)device;

@end
