//
//  CIOBarcodeGenerator
//  CheckItOut
//
//  Created by chris nielubowicz on 8/12/14.
//  Copyright (c) 2014 Assorted Intelligence. All rights reserved.
//

#import "CIOBarcodeGenerator.h"
#import "CIODevice.h"

@implementation CIOBarcodeGenerator

static const char *formatString = "%s";

+(CIImage *)qrcodeImageForInventoryItem:(CIODevice *)device
{
    if (device == nil)
    {
        NSLog(@"Device for %s was nil", __PRETTY_FUNCTION__);
        return nil;
    }
    
    char buffer[64];
    sprintf(buffer,formatString,[[device deviceIdentifier] cStringUsingEncoding:NSUTF8StringEncoding]);
    
    // Need to convert the string to a UTF-8 encoded NSData object
    NSData *stringData = [[NSString stringWithCString:buffer encoding:NSUTF8StringEncoding] dataUsingEncoding:NSUTF8StringEncoding];
    
    // Create the filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // Set the message content and error-correction level
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    
    // Send the image back
    return qrFilter.outputImage;
}

@end
