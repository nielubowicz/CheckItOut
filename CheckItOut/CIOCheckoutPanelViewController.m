//
//  CIOCheckPanelViewController.m
//  CheckItOut
//
//  Created by Chris Nielubowicz on 3/24/15.
//  Copyright (c) 2015 Assorted Intelligence. All rights reserved.
//

#import "CIOCheckoutPanelViewController.h"
#import "ParseNetworkManager.h"
#import "CIODevice.h"
#import "CIOUserManager.h"

@interface CIOCheckoutPanelViewController ()

@property (weak, nonatomic) IBOutlet UILabel *deviceModel;
@property (weak, nonatomic) IBOutlet UILabel *deviceLabel;

@end

@implementation CIOCheckoutPanelViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.deviceModel.text = self.currentDevice.deviceModel;
    self.deviceLabel.text = self.currentDevice.deviceLabel;
}

- (IBAction)cancelAction:(id)sender
{
    NSLog(@"%s not implemented yet", __PRETTY_FUNCTION__);
    [self removeFromParentViewController];
}

- (IBAction)checkoutAction:(id)sender
{
    NSLog(@"%s not implemented yet", __PRETTY_FUNCTION__);
    CIOUser *user = [CIOUserManager sharedUserManager].currentUser;
    [[ParseNetworkManager sharedNetworkManager] checkoutDevice:self.currentDevice toUser:user];
}

@end
