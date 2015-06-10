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
#import "CIOUserManager.h"
#import "CIODeviceDataSource.h"

@interface CIOAvailableDevicesTableViewController ()

@property (strong, nonatomic) CIODeviceDataSource *dataSource;
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
        strongSelf.dataSource = [[CIODeviceDataSource alloc] initWithDeviceList:strongSelf.deviceList forUser:[CIOUserManager sharedUserManager].currentUser];
        strongSelf.tableView.dataSource = strongSelf.dataSource;
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

@end
