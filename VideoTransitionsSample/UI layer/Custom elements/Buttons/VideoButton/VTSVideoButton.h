//
//  VTSVideoButton.h
//  VideoTransitionsSample
//
//  Created by Ruslan Shevtsov on 4/9/15.
//  Copyright (c) 2015 iQueSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VTSPlayerView;

@interface VTSVideoButton : UIButton

@property (nonatomic, strong) VTSPlayerView *playerView;

#pragma mark -
#pragma mark Update UI for preview

- (void)startPreview;

- (void)stopPreview;

@end
