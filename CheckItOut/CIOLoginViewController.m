//
//  CIOLoginViewController.m
//  CheckItOut
//
//  Created by Chris Nielubowicz on 3/25/15.
//  Copyright (c) 2015 Assorted Intelligence. All rights reserved.
//

#import "CIOLoginViewController.h"
#import "CIOUserManager.h"

@interface CIOLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userEmailTextField;

@end

@implementation CIOLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.userEmailTextField addTarget:self
                                action:@selector(tapGesture:)
                      forControlEvents:UIControlEventEditingDidEndOnExit];
}

- (IBAction)loginAction:(id)sender
{
    if (self.userEmailTextField.text.length > 0) {
    
        NSString *email = [NSString stringWithFormat:@"%@@mobiquityinc.com",
                           [self.userEmailTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
        
        __weak typeof(self) weakSelf = self;
        [[CIOUserManager sharedUserManager] loginUserWithEmail:email
                                             password:defaultPassword
                                           completion:^(CIOUser *user) {
                                               
                                               __strong typeof(self)strongSelf = weakSelf;
                                               [strongSelf performSegueWithIdentifier:@"dismissLogin" sender:strongSelf];
                                           }];
    }
}

- (IBAction)tapGesture:(id)sender
{
    [self.userEmailTextField resignFirstResponder];
}

@end
