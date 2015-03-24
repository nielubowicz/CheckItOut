//
//  ViewController.m
//  CheckItOut
//
//  Created by chris nielubowicz on 3/23/15.
//  Copyright (c) 2015 Assorted Intelligence. All rights reserved.
//

#import "MainViewController.h"
#import "ScanViewController.h"
#import "ParseNetworkManager.h"

@interface MainViewController ()

@property (weak, nonatomic) IBOutlet UIView *codeScanContainerView;
@property (weak, nonatomic) IBOutlet UIView *userPanelView;

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.userPanelView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.75];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)scanAction:(id)sender
{
    [[ParseNetworkManager sharedNetworkManager] loginUserWithEmail:@"cnielubowicz@mobiquityinc.com" password:@"junkpassword"];
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
                         
                         [scanViewController didMoveToParentViewController:self];
                     }];
}

@end
