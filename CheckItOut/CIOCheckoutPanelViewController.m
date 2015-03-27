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
#import "CIOUser.h"
#import "CIOSlackUserManager.h"

@interface CIOCheckoutPanelViewController () <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *deviceModel;
@property (weak, nonatomic) IBOutlet UILabel *currentOwnerLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkoutButton;

@property (strong, nonatomic) void (^completionBlock)(BOOL cancelled);

@end

@implementation CIOCheckoutPanelViewController

- (instancetype)initWithCompletion:(void(^)(BOOL cancelled))completionBlock
{
    if (self = [super initWithNibName:@"CheckoutPanelView" bundle:nil]) {
        _completionBlock = completionBlock;
    }
    return self;
}

#pragma mark - Custom Properties
- (void)setCurrentDevice:(CIODevice *)currentDevice
{
    _currentDevice = currentDevice;
    
    [UIView animateWithDuration:0.f
                     animations:^{
                         self.deviceModel.text = self.currentDevice.deviceModel;
                         NSString *checkoutString = nil;
                         NSString *checkoutButtonString = @"Checkout";
                         if (self.currentDevice.currentOwner == nil) {
                             checkoutString = @"This device is available for checkout.";
                         } else if ([self.currentDevice.currentOwner.objectID isEqualToString:[CIOUserManager sharedUserManager].currentUser.objectID]) {
                             checkoutString = @"You currently have this device checked out.";
                             checkoutButtonString = @"Checkin";
                         } else {
                             checkoutString = [NSString stringWithFormat:@"This device is checked out to: %@", self.currentDevice.currentOwner.userEmail];
                             checkoutButtonString = @"Poke in Slack";
                         }
                         self.currentOwnerLabel.text = checkoutString;
                         [self.checkoutButton setTitle:checkoutButtonString forState:UIControlStateNormal];
                     }];
}

#pragma mark - IBActions
- (IBAction)cancelAction:(id)sender
{
    if (self.completionBlock) {
        self.completionBlock(YES);
    }
}

- (IBAction)checkoutAction:(id)sender
{
    CIOUser *user = [CIOUserManager sharedUserManager].currentUser;

    __weak typeof(self) weakSelf = self;
    [[ParseNetworkManager sharedNetworkManager] checkoutDevice:self.currentDevice toUser:user
                                                          done:^(CIODevice *device) {

                                                              __strong typeof(self)strongSelf = weakSelf;
                                                              strongSelf.currentDevice = device;
                                                              
                                                              NSString *title = nil;
                                                              NSString *message = nil;
                                                              if (device.currentOwner) {
                                                                  title = @"Checkout";
                                                                  message = @"You successfully checked out this device!";
                                                              } else {
                                                                  title = @"Return";
                                                                  message = @"You returned this device!";
                                                              }
                                                              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                                                                              message:message
                                                                                                             delegate:self
                                                                                                    cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                              [alert show];
                                                              
                                                          } inUse:^(CIODevice *device, CIOUser *deviceOwner) {
                                                              
                                                              __strong typeof(self)strongSelf = weakSelf;
                                                              strongSelf.currentDevice = device;
                                                              [[CIOSlackUserManager sharedSlackManager] postMessageToUser:self.currentDevice.currentOwner.userEmail];
                                                              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                                                                              message:[NSString stringWithFormat:@"Poked %@", self.currentDevice.currentOwner.userEmail]
                                                                                                             delegate:self
                                                                                                    cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                              [alert show];
                                                              
                                                          } failure:^(NSURLRequest *request, NSError *error) {
                                                              
                                                              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                                              message:@"Failed to checkout or return this device"
                                                                                                             delegate:self
                                                                                                    cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                              [alert show];
                                                          }];
}

#pragma mark - UIAlertViewDelegate methods
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{    
    if (self.completionBlock) {
        self.completionBlock(NO);
    }
}

@end
