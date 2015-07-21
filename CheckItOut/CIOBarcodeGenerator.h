//
//  CIOBarcodeGenerator
//  CheckItOut
//
//  Created by chris nielubowicz on 8/12/14.
//  Copyright (c) 2014 Assorted Intelligence. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CIODevice;

@interface CIOBarcodeGenerator : NSObject

+(CIImage *)qrcodeImageForInventoryItem:(CIODevice *)device;

@end
