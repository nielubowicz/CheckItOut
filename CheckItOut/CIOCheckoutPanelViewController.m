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

@interface CIOCheckoutPanelViewController () <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *deviceModel;
@property (weak, nonatomic) IBOutlet UILabel *deviceLabel;

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.deviceModel.text = self.currentDevice.deviceModel;
    self.deviceLabel.text = self.currentDevice.deviceLabel;
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
    [[ParseNetworkManager sharedNetworkManager] checkoutDevice:self.currentDevice toUser:user
                                                          done:^(CIODevice *device) {
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
                                                              
                                                              NSString *message = [NSString stringWithFormat:@"This device is already in use. Please contact the current owner, %@", deviceOwner.username];
                                                              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Dammit Craig!"
                                                                                                              message:message
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
