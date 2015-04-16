//
//  VTSTransitionButton.m
//  VideoTransitionsSample
//
//  Created by Ruslan Shevtsov on 4/14/15.
//  Copyright (c) 2015 iQueSoft. All rights reserved.
//

#import "VTSTransitionButton.h"

// Frameworks
#import <AVFoundation/AVFoundation.h>

// UI
#import "VTSPlayerView.h"

@interface VTSTransitionButton ()

@property (nonatomic, strong) UIImageView *backgroundImageView;

@end

@implementation VTSTransitionButton

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    [self initialization];
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self initialization];
}

- (void)initialization {
    
    self.backgroundColor = [UIColor clearColor];
    
    self.layer.borderWidth = 2.0f;
    self.layer.borderColor = [UIColor colorWithRed:233.0f/255.0f green:56.0f/255.0f blue:59.0f/255.0f alpha:1.0f].CGColor;
    
    self.backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TransitionBackgroundImage"]];
    [self addSubview:self.backgroundImageView];
    
    self.playerView = [VTSPlayerView new];
    self.playerView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.playerView];
    
    [self setupDecorSubviewsSize];
}

- (void)setupDecorSubviewsSize {
    CGRect bounds = self.bounds;
    
    CGRect backgroundViewFrame = CGRectMake(4.0f,
                                            4.0f,
                                            bounds.size.width - 8.0f,
                                            bounds.size.height - 8.0f);
    
    self.backgroundImageView.frame = backgroundViewFrame;
    self.playerView.frame = backgroundViewFrame;
}

#pragma mark -
#pragma mark Setters

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    [self setupDecorSubviewsSize];
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    
    [self setupDecorSubviewsSize];
}

@end
