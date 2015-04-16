//
//  VTSBaseViewController.m
//  VideoTransitionsSample
//
//  Created by Ruslan Shevtsov on 4/9/15.
//  Copyright (c) 2015 iQueSoft. All rights reserved.
//

#import "VTSBaseViewController.h"

// Frameworks
#import <AVFoundation/AVFoundation.h>
#import "GPUImage.h"

@interface VTSBaseViewController ()

@property (nonatomic, strong) FRSGPUImageWrapper *gpuImageWrapper;

@end

@implementation VTSBaseViewController

#pragma mark -
#pragma mark Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.view isKindOfClass:[GPUImageView class]]) {
        GPUImageView *previewView = (GPUImageView *)self.view;
        previewView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
        
        self.gpuImageWrapper = [[FRSGPUImageWrapper alloc] initWithPreviewView:previewView
                                                                   orientation:[UIApplication sharedApplication].statusBarOrientation
                                                                 sessionPreset:AVCaptureSessionPreset352x288];
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.gpuImageWrapper startBlur];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.gpuImageWrapper stopBlur];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    
}

#pragma mark -
#pragma mark UIViewControllerRotation

- (BOOL)shouldAutorotate {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    self.gpuImageWrapper.videoCamera.outputImageOrientation = orientation;
    return YES;
}

@end
