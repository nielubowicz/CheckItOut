//
//  CIODeviceDataSource.h
//  CheckItOut
//
//  Created by chris nielubowicz on 3/30/15.
//  Copyright (c) 2015 Assorted Intelligence. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CIOUser;

@interface CIODeviceDataSource : NSObject <UITableViewDataSource>

@property (strong, nonatomic, readonly) NSArray *sectionedDeviceList;
@property (strong, nonatomic, readonly) CIOUser *user;

- (instancetype)initWithDeviceList:(NSArray *)deviceList forUser:(CIOUser *)user;

@end
