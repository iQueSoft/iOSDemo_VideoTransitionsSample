//
//  VTSPlayerView.h
//  VideoTransitionsSample
//
//  Created by Ruslan Shevtsov on 4/15/15.
//  Copyright (c) 2015 iQueSoft. All rights reserved.
//

#import "VTSIgnoreTouchesView.h"

@class AVPlayer;

@interface VTSPlayerView : VTSIgnoreTouchesView

@property (nonatomic, strong) AVPlayer *player;

@end
