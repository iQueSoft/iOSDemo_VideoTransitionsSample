//
//  VTSPlayerView.m
//  VideoTransitionsSample
//
//  Created by Ruslan Shevtsov on 4/15/15.
//  Copyright (c) 2015 iQueSoft. All rights reserved.
//

#import "VTSPlayerView.h"

// Frameworks
#import <AVFoundation/AVFoundation.h>

@interface VTSPlayerView ()

@end

@implementation VTSPlayerView

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (AVPlayer *)player {
    return [(AVPlayerLayer *)[self layer] player];
}

- (void)setPlayer:(AVPlayer *)player {
    ((AVPlayerLayer *)self.layer).videoGravity = AVLayerVideoGravityResizeAspectFill;
    [(AVPlayerLayer *)[self layer] setPlayer:player];
}

@end
