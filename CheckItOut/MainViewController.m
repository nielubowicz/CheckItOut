//
//  ViewController.m
//  CheckItOut
//
//  Created by chris nielubowicz on 3/23/15.
//  Copyright (c) 2015 Assorted Intelligence. All rights reserved.
//

#import "MainViewController.h"
#import "ScanViewController.h"
#import "CIOCheckoutPanelViewController.h"
#import "CIOUserManager.h"
#import "CIOUser.h"

@interface MainViewController () <QRScannerDelegate>

@property (weak, nonatomic) IBOutlet UIView *codeScanContainerView;
@property (weak, nonatomic) IBOutlet UIView *checkoutPanelContainerView;
@property (weak, nonatomic) IBOutlet UIView *userPanelView;
@property (weak, nonatomic) IBOutlet UILabel *currentUserLabel;

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.userPanelView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.75];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    __weak typeof(self) weakSelf = self;
    [[CIOUserManager sharedUserManager] retrieveLoggedInUserWithCompletion:^(CIOUser *user) {
        
        __strong typeof(self)strongSelf = weakSelf;
        strongSelf.currentUserLabel.text = user.userEmail;
    }];
}

#pragma mark - IBActions
- (IBAction)scanAction:(id)sender
{
    ScanViewController *scanViewController = [[ScanViewController alloc] initWithNibName:nil bundle:nil];
    [self addChildViewController:scanViewController];
    
    [UIView animateWithDuration:2.5
                          delay:0.f
         usingSpringWithDamping:0.5
          initialSpringVelocity:10
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         
                         scanViewController.view.frame = self.codeScanContainerView.bounds;
                         [self.codeScanContainerView addSubview:scanViewController.view];
                         
                         
                     } completion:^(BOOL finished) {
                         
                         scanViewController.delegate = self;
                         [scanViewController didMoveToParentViewController:self];
                     }];
}
- (IBAction)registerAction:(id)sender
{
    __weak typeof(self) weakSelf = self;
    [[CIOUserManager sharedUserManager] createUserWithEmail:@"cnielubowicz@mobiquityinc.com"
                                                   password:defaultPassword
                                                 completion:^(CIOUser *user) {
                                                     
                                                     __strong typeof(self)strongSelf = weakSelf;
                                                     strongSelf.currentUserLabel.text = user.userEmail;
                                                 }];
}

- (IBAction)loginAction:(id)sender
{
    CIOUser *user = [[CIOUser alloc] init];
    user.username = @"cnielubowicz@mobiquityinc.com";
    user.userEmail = user.username;
    
    __weak typeof(self) weakSelf = self;
    [[CIOUserManager sharedUserManager] loginUser:user
                                         password:defaultPassword
                                       completion:^(CIOUser *user) {
                                           
                                           __strong typeof(self)strongSelf = weakSelf;
                                           strongSelf.currentUserLabel.text = user.userEmail;
                                       }];
}

#pragma mark - QRScannerDelegate
- (void)scannerViewController:(ScanViewController *)scannerViewController didScanDevice:(CIODevice *)device
{
    if ([[self childViewControllers] count] == 1) {
        CIOCheckoutPanelViewController *checkoutPanelViewController = [[CIOCheckoutPanelViewController alloc] initWithNibName:@"CheckoutPanelView" bundle:nil];
        checkoutPanelViewController.currentDevice = device;

        [self addChildViewController:checkoutPanelViewController];
        
        [UIView animateWithDuration:2.5
                              delay:0.f
             usingSpringWithDamping:0.5
              initialSpringVelocity:10
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             
                             checkoutPanelViewController.view.frame = self.checkoutPanelContainerView.bounds;
                             [self.checkoutPanelContainerView addSubview:checkoutPanelViewController.view];
                             [self.view bringSubviewToFront:self.checkoutPanelContainerView];                             
                             
                         } completion:^(BOOL finished) {

                             [checkoutPanelViewController didMoveToParentViewController:self];
                         }];
    }
}

@end
