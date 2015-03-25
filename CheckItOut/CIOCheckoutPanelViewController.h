//
//  CIOCheckPanelViewController.h
//  CheckItOut
//
//  Created by Chris Nielubowicz on 3/24/15.
//  Copyright (c) 2015 Assorted Intelligence. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CIODevice;

@interface CIOCheckoutPanelViewController : UIViewController

@property (strong, nonatomic) CIODevice *currentDevice;

- (instancetype)initWithCompletion:(void(^)())completionBlock;

@end
