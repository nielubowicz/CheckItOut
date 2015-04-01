//
//  CIODeviceDataSource.m
//  CheckItOut
//
//  Created by chris nielubowicz on 3/30/15.
//  Copyright (c) 2015 Assorted Intelligence. All rights reserved.
//

#import "CIODeviceDataSource.h"
#import "CIOUser.h"
#import "CIODevice.h"

@interface CIODeviceDataSource ()

@property (strong, nonatomic) NSArray *sectionedDeviceListTitles;

@end

@implementation CIODeviceDataSource

static NSString *const kCIODeviceCellIdentifier = @"DeviceCell";
static NSString *const kCIODeviceSectionHeaderMyDevices = @"My Devices";
static NSString *const kCIODeviceSectionHeaderCheckedOut = @"Checked Out Devices";
static NSString *const kCIODeviceSectionHeaderAvailable = @"Available Devices";

- (instancetype)initWithDeviceList:(NSArray *)deviceList forUser:(CIOUser *)user
{
    if (self = [super init]) {
        
        _user = [user copy];
        
        NSArray *currentUsersDevices;
        if (_user != nil) {
            currentUsersDevices = [deviceList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"currentOwner.objectID = %@", user.objectID]];
        }
        NSArray *availableDevices = [deviceList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"currentOwner = nil"]];
        NSArray *checkedOutDevices = [deviceList filteredArrayUsingPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[ [NSPredicate predicateWithFormat:@"currentOwner != nil"],
                                                                                                                                   [NSPredicate predicateWithFormat:@"currentOwner.objectID != %@", user.objectID] ]]];
        NSMutableArray *deviceSectionTitles = [NSMutableArray array];
        NSMutableArray *deviceArray = [NSMutableArray array];
        if (currentUsersDevices.count > 0) {
            [deviceArray addObject:currentUsersDevices];
            [deviceSectionTitles addObject:kCIODeviceSectionHeaderMyDevices];
        }
        
        if (checkedOutDevices.count > 0) {
            [deviceArray addObject:checkedOutDevices];
            [deviceSectionTitles addObject:kCIODeviceSectionHeaderCheckedOut];
        }
        
        if (availableDevices.count > 0) {
            [deviceArray addObject:availableDevices];
            [deviceSectionTitles addObject:kCIODeviceSectionHeaderAvailable];
        }
        _sectionedDeviceList = [deviceArray copy];
        _sectionedDeviceListTitles = [deviceSectionTitles copy];
    }
    return self;
}

- (CGFloat)hoursSinceCheckoutDate:(NSDate *)checkout
{
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:checkout];
    CGFloat hours = timeInterval / 60.0 / 60.0;
    return hours;
}

#pragma mark - UITableViewDataSource methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return self.sectionedDeviceList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    NSArray *currentDeviceList = self.sectionedDeviceList[section];
    return currentDeviceList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSArray *currentDeviceList = self.sectionedDeviceList[indexPath.section];
    CIODevice *device = currentDeviceList[indexPath.row];

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCIODeviceCellIdentifier];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@", device.deviceModel, device.deviceOperatingSystem];
    
    if (device.currentOwner != nil) {
        cell.textLabel.text = [cell.textLabel.text stringByAppendingFormat:@" checked out by %@", device.currentOwner.userEmail];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"for %.1f hours", [self hoursSinceCheckoutDate:device.lastCheckout]];
        [cell.textLabel setTextColor:[UIColor redColor]];
    } else {
        cell.detailTextLabel.text = nil;
        [cell.textLabel setTextColor:[UIColor blackColor]];
    }
    
    [cell.detailTextLabel setTextColor:cell.textLabel.textColor];

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.sectionedDeviceListTitles[section];
}

@end
