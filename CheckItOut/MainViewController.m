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
@property (weak, nonatomic) IBOutlet UILabel *tapAnywhereLabel;

@property (strong, nonatomic) CIOCheckoutPanelViewController *checkoutPanelViewController;

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
        if (!user.isEmailVerified) {
            [strongSelf promptForVerification];
        }
    }];
}

- (void)promptForVerification
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                    message:@"You may not checkout a device until you have verified your email. Please check your email and respond."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
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
                         [self.tapAnywhereLabel setAlpha:0.f];
                         
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
    if (self.checkoutPanelViewController == nil) {
        
        __weak typeof(self) weakSelf = self;
        self.checkoutPanelViewController = [[CIOCheckoutPanelViewController alloc] initWithCompletion:^{

            __strong typeof(self)strongSelf = weakSelf;
            [strongSelf.checkoutPanelViewController willMoveToParentViewController:nil];
            [UIView animateWithDuration:1.5
                                  delay:0.f
                 usingSpringWithDamping:1.f
                  initialSpringVelocity:10
                                options:UIViewAnimationOptionBeginFromCurrentState
                             animations:^{
                                 
                                 strongSelf.checkoutPanelViewController.view.alpha = 0.f;

                             } completion:^(BOOL finished) {
                                 
                                 [strongSelf.checkoutPanelViewController.view removeFromSuperview];
                                 [strongSelf.checkoutPanelViewController removeFromParentViewController];
                                 strongSelf.checkoutPanelViewController = nil;
                             }];
        }];
        self.checkoutPanelViewController.currentDevice = device;

        [self addChildViewController:self.checkoutPanelViewController];
        if (![[self.checkoutPanelViewController.view superview] isEqual:self.checkoutPanelViewController]) {
            self.checkoutPanelViewController.view.frame = self.checkoutPanelContainerView.bounds;
            self.checkoutPanelViewController.view.alpha = 0.f;
            [self.checkoutPanelContainerView addSubview:self.checkoutPanelViewController.view];
        }

        [UIView animateWithDuration:2.5
                              delay:0.f
             usingSpringWithDamping:1.f
              initialSpringVelocity:10
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             
                             self.checkoutPanelViewController.view.alpha = 1.f;
                             [self.view bringSubviewToFront:self.checkoutPanelContainerView];
                             
                         } completion:^(BOOL finished) {

                             [self.checkoutPanelViewController didMoveToParentViewController:self];
                         }];
    }
}

@end
