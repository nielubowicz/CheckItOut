//
//  ScanViewController.h
//  CheckItOut
//
//  Created by chris nielubowicz on 3/23/15.
//  Copyright (c) 2015 Assorted Intelligence. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CIODevice;

@protocol QRScannerDelegate;

@interface ScanViewController : UIViewController

@property (weak, nonatomic) id<QRScannerDelegate> delegate;

@end

@protocol QRScannerDelegate <NSObject>

- (void)scannerViewController:(ScanViewController *)scannerViewController didScanDevice:(CIODevice *)device;

@end
