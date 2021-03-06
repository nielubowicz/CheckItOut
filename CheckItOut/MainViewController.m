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
#import "CIOLoginViewController.h"

@interface MainViewController () <QRScannerDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *codeScanContainerView;
@property (weak, nonatomic) IBOutlet UIView *checkoutPanelContainerView;
@property (weak, nonatomic) IBOutlet UIView *userPanelView;
@property (weak, nonatomic) IBOutlet UILabel *currentUserLabel;
@property (weak, nonatomic) IBOutlet UILabel *tapAnywhereLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

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
    
    [self setupViewForUser:[[CIOUserManager sharedUserManager] currentUser]];
    [[CIOUserManager sharedUserManager] addObserver:self forKeyPath:@"currentUser" options:NSKeyValueObservingOptionNew context:nil];
    
    if ([[CIOUserManager sharedUserManager] currentUser] == nil) {
        __weak typeof(self) weakSelf = self;
        [[CIOUserManager sharedUserManager] retrieveLoggedInUserWithCompletion:^(CIOUser *user) {
            
            __strong typeof(self)strongSelf = weakSelf;
            if (user && !user.isEmailVerified) {
                [strongSelf promptForVerification];
            }
        }];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[CIOUserManager sharedUserManager] removeObserver:self forKeyPath:@"currentUser"];
}

- (void)promptForVerification
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                    message:@"You may not checkout a device until you have verified your email. Please check your email and respond."
                                                   delegate:self
                                          cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (void)setupViewForUser:(CIOUser *)user
{
    if (user) {
        [self.loginButton setTitle:@"Logout" forState:UIControlStateNormal];
        self.currentUserLabel.text = user.userEmail;
    } else {
        [self.loginButton setTitle:@"Login" forState:UIControlStateNormal];
        self.currentUserLabel.text = nil;
    }
}

#pragma mark - IBActions
- (IBAction)scanAction:(id)sender
{
    if ([[CIOUserManager sharedUserManager] currentUser] == nil) {
        [self loginAction:self];
    }
    
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
                         [scanViewController startScanning];
                     }];
}

- (IBAction)registerAction:(id)sender
{
    NSLog(@"%s not implemented yet", __PRETTY_FUNCTION__);
}

- (IBAction)loginAction:(id)sender
{
    if ([[CIOUserManager sharedUserManager] currentUser] == nil) {
        CIOLoginViewController *loginViewController = [[UIStoryboard storyboardWithName:@"LoginStoryboard" bundle:nil] instantiateInitialViewController];
        [self presentViewController:loginViewController animated:YES completion:NULL];
    } else {
        [[CIOUserManager sharedUserManager] logoutCurrentUser];
        [self.loginButton setTitle:@"Login" forState:UIControlStateNormal];
    }
}

#pragma mark - QRScannerDelegate
- (void)scannerViewController:(ScanViewController *)scannerViewController didScanDevice:(CIODevice *)device
{
    if (self.checkoutPanelViewController == nil) {
        
        __weak typeof(self) weakSelf = self;
        self.checkoutPanelViewController = [[CIOCheckoutPanelViewController alloc] initWithCompletion:^(BOOL cancelled){

            __strong typeof(self)strongSelf = weakSelf;
            if (!cancelled) {
                [scannerViewController stopScanning];
                [scannerViewController willMoveToParentViewController:nil];
            }
            
            [strongSelf.checkoutPanelViewController willMoveToParentViewController:nil];
            [UIView animateWithDuration:1.5
                                  delay:0.f
                 usingSpringWithDamping:1.f
                  initialSpringVelocity:10
                                options:UIViewAnimationOptionBeginFromCurrentState
                             animations:^{
                                 
                                 if (!cancelled) {
                                     scannerViewController.view.alpha = 0.f;
                                     strongSelf.tapAnywhereLabel.alpha = 1.f;
                                 }
                                 strongSelf.checkoutPanelViewController.view.alpha = 0.f;
                                 
                             } completion:^(BOOL finished) {
                                 if (!cancelled) {
                                     [scannerViewController.view removeFromSuperview];
                                     [scannerViewController removeFromParentViewController];
                                 }
                                 [strongSelf.checkoutPanelViewController.view removeFromSuperview];
                                 [strongSelf.view sendSubviewToBack:strongSelf.checkoutPanelContainerView];
                                 [strongSelf.checkoutPanelViewController removeFromParentViewController];
                                 strongSelf.checkoutPanelViewController = nil;
                             }];
        }];
        self.checkoutPanelViewController.currentDevice = device;

        [self addChildViewController:self.checkoutPanelViewController];
        self.checkoutPanelViewController.view.frame = self.checkoutPanelContainerView.bounds;
        self.checkoutPanelViewController.view.alpha = 0.f;
        [self.checkoutPanelContainerView addSubview:self.checkoutPanelViewController.view];

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
    } else {
        [UIView animateWithDuration:2.5
                              delay:0.f
             usingSpringWithDamping:1.f
              initialSpringVelocity:10
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             
                             self.checkoutPanelViewController.currentDevice = device;
                             
                         } completion:NULL];
    }    
}

#pragma mark - Dismiss segue
- (IBAction)unwindToMainView:(UIStoryboardSegue *)unwindSegue
{
    
}

#pragma mark - UIAlertViewDelegate methods
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
//    abort();
}

#pragma mark - KVO 
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    CIOUser *user = [[CIOUserManager sharedUserManager] currentUser];
    [self setupViewForUser:user];
}

@end
