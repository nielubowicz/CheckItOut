//
//  ScanViewController.m
//  CheckItOut
//
//  Created by chris nielubowicz on 8/11/14.
//  Copyright (c) 2014 Assorted Intelligence. All rights reserved.
//

#import "ScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "CIODevice.h"
#import "ParseNetworkManager.h"

@interface ScanViewController () <AVCaptureMetadataOutputObjectsDelegate>

@property (strong,nonatomic) AVCaptureSession *session;
@property (strong,nonatomic) AVCaptureDevice *device;
@property (strong,nonatomic) AVCaptureDeviceInput *input;
@property (strong,nonatomic) AVCaptureMetadataOutput *output;
@property (strong,nonatomic) AVCaptureVideoPreviewLayer *prevLayer;
@property (strong,nonatomic) UIView *highlightView;

@end

@implementation ScanViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.highlightView = [[UIView alloc] init];
    self.highlightView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
    // TODO: translate to auto-layout
    self.highlightView.layer.borderColor = [UIColor greenColor].CGColor;
    self.highlightView.layer.borderWidth = 3;
    
    self.session = [[AVCaptureSession alloc] init];
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&error];
    if (self.input) {
        [self.session addInput:self.input];
    } else {
        NSLog(@"Error: %@", error);
    }
    
    self.output = [[AVCaptureMetadataOutput alloc] init];
    [self.session addOutput:self.output];
    
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [self.output setMetadataObjectTypes:[self.output availableMetadataObjectTypes]];
    
    self.prevLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.prevLayer.frame = self.view.bounds;
    self.prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:self.prevLayer];
}

- (void)startScanning
{
    [self.session startRunning];
    [self.view addSubview:self.highlightView];
    [self.view bringSubviewToFront:self.highlightView];
}

- (void)stopScanning
{
    [self.highlightView removeFromSuperview];
    [self.session stopRunning];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    CGRect highlightViewRect = CGRectZero;
    AVMetadataMachineReadableCodeObject *barCodeObject;
    NSString *detectionString = nil;
    NSArray *barCodeTypes = @[AVMetadataObjectTypeQRCode];
    
    for (AVMetadataObject *metadata in metadataObjects) {
        for (NSString *type in barCodeTypes) {
            if ([metadata.type isEqualToString:type])
            {
                barCodeObject = (AVMetadataMachineReadableCodeObject *)[self.prevLayer transformedMetadataObjectForMetadataObject:(AVMetadataMachineReadableCodeObject *)metadata];
                highlightViewRect = barCodeObject.bounds;
                self.highlightView.frame = highlightViewRect;

                detectionString = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
                break;
            }
        }
        
        if (detectionString != nil) {

            if ([self.delegate respondsToSelector:@selector(scannerViewController:didScanDevice:)]) {
                CIODevice *device = [[CIODevice alloc] initWithDetectionString:detectionString];
                
                __weak typeof(self) weakSelf = self;
                [[ParseNetworkManager sharedNetworkManager] fetchDeviceWithIdentifier:device.objectID
                                                                                 done:^(CIODevice *device) {
                                                                                     
                                                                                     __strong typeof(self)strongSelf = weakSelf;
                                                                                     [strongSelf.delegate scannerViewController:strongSelf didScanDevice:device];
                                                                                 } failure:^(NSURLRequest *request, NSError *error) {
                                                                                     
                                                                                 }];

            }
            break;
        }
    }
}

@end