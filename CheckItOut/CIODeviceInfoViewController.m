//
//  CIOAddDeviceViewController.m
//  CheckItOut
//
//  Created by chris nielubowicz on 7/18/15.
//  Copyright (c) 2015 Assorted Intelligence. All rights reserved.
//

#import "CIODeviceInfoViewController.h"
#import "CIODevice.h"
#import "CIOBarcodeGenerator.h"
#import "UIImage+NonInterpolatedImage.h"

@interface CIODeviceInfoViewController () <UIPrintInteractionControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *printButton;
@property (weak, nonatomic) IBOutlet UIImageView *deviceQRCode;

@end

@implementation CIODeviceInfoViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.title = [NSString stringWithFormat:@"Print %@", self.device.deviceModel];
    self.deviceQRCode.image = [UIImage createNonInterpolatedUIImageFromCIImage:[CIOBarcodeGenerator qrcodeImageForInventoryItem:self.device]
                                                                     withScale:3.0];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [super viewWillDisappear:animated];
}

- (IBAction)printQRCodeForDevice:(id)sender
{
    NSAssert(self.device != nil, @"Device cannot be nil");
    
    if ([UIPrintInteractionController isPrintingAvailable]) {
        UIPrintInteractionController *pic = [UIPrintInteractionController sharedPrintController];
        pic.delegate = self;
        
        UIPrintInfo *printInfo = [UIPrintInfo printInfo];
        printInfo.outputType = UIPrintInfoOutputPhotoGrayscale;
        printInfo.jobName = self.device.deviceIdentifier;
        pic.printInfo = printInfo;
        
        NSAssert(self.deviceQRCode.image != nil, @"Image to print cannot be nil");
        pic.printingItem = self.deviceQRCode.image;
        
        [pic presentAnimated:YES completionHandler:^(UIPrintInteractionController *printInteractionController, BOOL completed, NSError *error) {
            if (!completed && error) {
                NSLog(@"Printing could not complete because of error: %@", error);
            }
        }];
    }
}


#pragma mark -
#pragma mark UIPrintInteractionControllerDelegate

- (UIViewController *)printInteractionControllerParentViewController:(UIPrintInteractionController *)printInteractionController
{
    return self;
}

@end
