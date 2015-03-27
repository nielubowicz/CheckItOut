//
//  CIOAvailableDevicesTableViewController.m
//  CheckItOut
//
//  Created by chris nielubowicz on 3/24/15.
//  Copyright (c) 2015 Assorted Intelligence. All rights reserved.
//

#import "CIOAvailableDevicesTableViewController.h"
#import "ParseNetworkManager.h"
#import "CIODevice.h"
#import "CIOUser.h"

@interface CIOAvailableDevicesTableViewController ()

@property (copy, nonatomic) NSArray *deviceList;

@end

@implementation CIOAvailableDevicesTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.contentInset = UIEdgeInsetsMake(12, 0, 0, 0); // inset so content is not covered by the status-bar
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshDeviceList:) forControlEvents:UIControlEventValueChanged];
    [self setRefreshControl:refreshControl];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshDeviceList:nil];
}

- (void)refreshDeviceList:(id)sender
{
    __weak __typeof__(self) weakSelf = self;
    [[ParseNetworkManager sharedNetworkManager] fetchListOfAvailableDevicesWithDone:^(NSArray *devices) {
        
        __strong __typeof__(self) strongSelf = weakSelf;
        strongSelf.deviceList = devices;
        [strongSelf.tableView reloadData];
        [strongSelf.refreshControl endRefreshing];
        
    } failure:^(NSURLRequest *request, NSError *error) {
        
        NSLog(@"%@", error);
        __strong __typeof__(self) strongSelf = weakSelf;
        [strongSelf.refreshControl endRefreshing];
    }];
}

- (CGFloat)hoursSinceCheckoutDate:(NSDate *)checkout
{
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:checkout];
    CGFloat hours = timeInterval / 60.0 / 60.0;
    return hours;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.deviceList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceCell" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"DeviceCell"];
    }
    
    CIODevice *device = self.deviceList[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@", device.deviceModel, device.deviceOperatingSystem];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ (%@)", device.deviceLabel, device.deviceIdentifier];
    
    if (device.currentOwner != nil) {
        cell.textLabel.text = [cell.textLabel.text stringByAppendingFormat:@" checked out by %@", device.currentOwner.userEmail];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"for %.1f hours", [self hoursSinceCheckoutDate:device.lastCheckout]];
        [cell.textLabel setTextColor:[UIColor redColor]];
    } else {
        [cell.textLabel setTextColor:[UIColor blackColor]];
    }
    
    [cell.detailTextLabel setTextColor:cell.textLabel.textColor];
    return cell;
}

@end
