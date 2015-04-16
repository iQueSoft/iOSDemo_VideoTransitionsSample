//
//  VTSAutoReplayPlayer.m
//  VideoTransitionsSample
//
//  Created by Ruslan Shevtsov on 4/15/15.
//  Copyright (c) 2015 iQueSoft. All rights reserved.
//

#import "VTSAutoReplayPlayer.h"

@implementation VTSAutoReplayPlayer

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.volume = 0.0f;
    self.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:nil];
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

#pragma mark -
#pragma mark Notification

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    if (notification.object != self.currentItem) {
        return;
    }
    [self pause];
    [self.currentItem seekToTime:kCMTimeZero];
    [self play];
}

@end
