//
//  VTSTransitionsViewController.m
//  VideoTransitionsSample
//
//  Created by Ruslan Shevtsov on 4/14/15.
//  Copyright (c) 2015 iQueSoft. All rights reserved.
//

#import "VTSTransitionsViewController.h"

// Frameworks
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

// Business facade
#import "VTSBusinessFacade.h"

// UI
#import "PagedFlowView.h"
#import "VTSTransitionButton.h"
#import "VTSPlayerView.h"

NSString * const kHideTransitionsListViewNotificationString = @"kHideFiltersListViewNotificationString";

@interface VTSTransitionsViewController () <PagedFlowViewDelegate, PagedFlowViewDataSource>

@property (weak, nonatomic) IBOutlet PagedFlowView *transitionsPagedFlowView;

@property (nonatomic, strong) NSMutableDictionary *cells;

@property (nonatomic, weak) VTSTransitionButton *currentPagedFlowViewCell;

@property (nonatomic, assign) VTSTransitionType tempTransitionType;

@end

@implementation VTSTransitionsViewController

#pragma mark -
#pragma mark Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.transitionsPagedFlowView.delegate = self;
    self.transitionsPagedFlowView.dataSource = self;
    self.transitionsPagedFlowView.minimumPageAlpha = 0.3;
    self.transitionsPagedFlowView.minimumPageScale = 0.7;
    
    for (NSInteger index = 0; index < VTSTransitionsCount; index++) {
        VTSTransitionButton *pagedFlowViewCell = [[VTSTransitionButton alloc] init];
        [pagedFlowViewCell addTarget:self action:@selector(chooseTransition:) forControlEvents:UIControlEventTouchUpInside];
        pagedFlowViewCell.layer.borderColor = [UIColor whiteColor].CGColor;
        [self.cells setObject:pagedFlowViewCell forKey:@(index)];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    VTSBusinessFacade *businessFacade = [VTSBusinessFacade sharedBusinessFacade];
    
    self.tempTransitionType = businessFacade.transitionType;
    
    self.currentPagedFlowViewCell = self.cells[@(self.tempTransitionType)];
    self.currentPagedFlowViewCell.layer.borderColor = [UIColor colorWithRed:233.0f/255.0f green:56.0f/255.0f blue:59.0f/255.0f alpha:1.0f].CGColor;
    
    self.currentPagedFlowViewCell = self.cells[@(self.tempTransitionType)];
    self.currentPagedFlowViewCell.playerView.player = businessFacade.transitionPreviewPlayer;
    [self.transitionsPagedFlowView scrollToPage:self.tempTransitionType];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}

#pragma mark -
#pragma mark Lazy load

- (NSMutableDictionary *)cells {
    if (_cells == nil) {
        _cells = [NSMutableDictionary dictionary];
    }
    return _cells;
}

#pragma mark -
#pragma mark IBActions

- (IBAction)closeAction:(id)sender {
    [[VTSBusinessFacade sharedBusinessFacade] setTransitionType:self.tempTransitionType];
    [[NSNotificationCenter defaultCenter] postNotificationName:kHideTransitionsListViewNotificationString object:self userInfo:nil];
}

- (void)chooseTransition:(id)sender {
    
    VTSTransitionButton *prevButton = [self.cells objectForKey:@(self.tempTransitionType)];
    
    prevButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.tempTransitionType = [(NSNumber *)[[self.cells allKeysForObject:sender] lastObject] integerValue];
    ((VTSTransitionButton *)sender).layer.borderColor = [UIColor colorWithRed:233.0f/255.0f green:56.0f/255.0f blue:59.0f/255.0f alpha:1.0f].CGColor;
}

#pragma mark -
#pragma mark PagedFlowViewDelegate

- (CGSize)sizeForPageInFlowView:(PagedFlowView *)flowView {
    return CGSizeMake(160.0f, 90.0f);
}

- (void)flowView:(PagedFlowView *)flowView didScrollToPageAtIndex:(NSInteger)index {
    [[VTSBusinessFacade sharedBusinessFacade] setTransitionType:(VTSTransitionType)index];
    
    self.currentPagedFlowViewCell.playerView.player = nil;
    self.currentPagedFlowViewCell = self.cells[@(index)];
    self.currentPagedFlowViewCell.playerView.player = [VTSBusinessFacade sharedBusinessFacade].transitionPreviewPlayer;
}

#pragma mark -
#pragma mark PagedFlowViewDataSource

- (NSInteger)numberOfPagesInFlowView:(PagedFlowView *)flowView {
    return VTSTransitionsCount;
}

- (UIView *)flowView:(PagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index {
    VTSTransitionButton *pagedFlowViewCell = self.cells[@(index)];
    return pagedFlowViewCell;
}

@end
