//
//  VTSPlayerViewController.m
//  VideoTransitionsSample
//
//  Created by Ruslan Shevtsov on 4/15/15.
//  Copyright (c) 2015 iQueSoft. All rights reserved.
//

#import "VTSPlayerViewController.h"

// Frameworks
#import <AVFoundation/AVFoundation.h>

// Business facade
#import "VTSBusinessFacade.h"

// UI
#import "VTSPlayerView.h"

// Helpers
#import "DurationStringFromTimeInterval.h"

NSString * const kHidePlayerViewNotificationString = @"kHidePlayerViewNotificationString";

@interface VTSPlayerViewController ()

@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *pauseButton;
@property (weak, nonatomic) IBOutlet VTSPlayerView *playerView;
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastTimeLabel;

@property (nonatomic, strong) NSTimer *progressTimer;

@end

@implementation VTSPlayerViewController

#pragma mark -
#pragma mark Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.progressTimer = [NSTimer timerWithTimeInterval:0.1
                                                 target:self
                                               selector:@selector(timerDidFire:)
                                               userInfo:nil
                                                repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:self.progressTimer
                              forMode:NSDefaultRunLoopMode];
    
    self.progressSlider.value = 0.0f;
    
    AVPlayer *player = [[VTSBusinessFacade sharedBusinessFacade] playerWithCurrentVideo];
    
    if (player == nil) {
        return;
    }
    
    self.playerView.player = player;
    
    CGFloat duration = CMTimeGetSeconds(player.currentItem.duration);
    self.progressSlider.maximumValue = duration;
    self.lastTimeLabel.text = DurationFromTimeInterval(duration);
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
 
    AVPlayer *player = self.playerView.player;
    if (player) {
        self.playButton.hidden = YES;
        self.pauseButton.hidden = NO;
        [player play];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    [self.playerView.player pause];
    self.playerView.player = nil;
    
    if (self.progressTimer != nil) {
        if ([self.progressTimer isValid]) {
            [self.progressTimer invalidate];
        }
        self.progressTimer = nil;
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    
}

#pragma mark -
#pragma mark IBActions

- (IBAction)closeAction:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:kHidePlayerViewNotificationString object:self userInfo:nil];
}

- (IBAction)playAction:(id)sender {
    AVPlayer *player = self.playerView.player;
    if (player) {
        self.playButton.hidden = YES;
        self.pauseButton.hidden = NO;
        [player play];
    }
}

- (IBAction)pauseAction:(id)sender {
    AVPlayer *player = self.playerView.player;
    if (player) {
        self.pauseButton.hidden = YES;
        self.playButton.hidden = NO;
        [player pause];
    }
}

#pragma mark -
#pragma mark Update progress UI

- (void)timerDidFire:(NSTimer *)timer {
    [self updateProgresUI];
}

- (void)updateProgresUI {
    
    AVPlayerItem *playerItem = self.playerView.player.currentItem;
    
    CGFloat currentTime = CMTimeGetSeconds(playerItem.currentTime);
    
    self.progressSlider.value = currentTime;
    self.currentTimeLabel.text = DurationFromTimeInterval(currentTime);
}

#pragma mark -
#pragma mark Notifications

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    if (notification.object == self.playerView.player.currentItem) {
        [self.playerView.player seekToTime:kCMTimeZero];
        self.pauseButton.hidden = YES;
        self.playButton.hidden = NO;
    }
}

@end
