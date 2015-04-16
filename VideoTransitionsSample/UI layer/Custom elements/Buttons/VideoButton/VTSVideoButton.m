//
//  VTSVideoButton.m
//  VideoTransitionsSample
//
//  Created by Ruslan Shevtsov on 4/9/15.
//  Copyright (c) 2015 iQueSoft. All rights reserved.
//

#import "VTSVideoButton.h"

// UI
#import "VTSIgnoreTouchesView.h"
#import "VTSPlayerView.h"

// ======= VTSDecorView =======

@interface VTSDecorView : VTSIgnoreTouchesView

@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) CGFloat lineProportion;
@property (nonatomic, assign) CGFloat lineLenght;

@property (nonatomic, assign) BOOL showCross;

@end

@implementation VTSDecorView

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.backgroundColor = [UIColor clearColor];
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:233.0f/255.0f green:56.0f/255.0f blue:59.0f/255.0f alpha:1.0f].CGColor);
    
    CGContextSetLineWidth(context, self.lineWidth);
    
    CGSize selfSize = self.frame.size;
    
    // 1
    CGContextMoveToPoint(context, 0.0f, self.lineWidth / 2.0f);
    
    CGContextAddLineToPoint(context, self.lineLenght, self.lineWidth / 2.0f);
    
    // 2
    CGContextMoveToPoint(context, self.lineWidth / 2.0f, 0.0f);
    
    CGContextAddLineToPoint(context, self.lineWidth / 2.0f, self.lineLenght);
    
    // 3
    CGContextMoveToPoint(context, self.lineWidth / 2.0f, selfSize.height);
    
    CGContextAddLineToPoint(context, self.lineWidth / 2.0f, selfSize.height - self.lineLenght);
    
    // 4
    CGContextMoveToPoint(context, self.lineWidth / 2.0f, selfSize.height - self.lineWidth / 2.0f);
    
    CGContextAddLineToPoint(context, self.lineLenght, selfSize.height - self.lineWidth / 2.0f);
    
    // 5
    CGContextMoveToPoint(context, selfSize.width + self.lineWidth / 2.0f, self.lineWidth / 2.0f);
    
    CGContextAddLineToPoint(context, selfSize.width - self.lineLenght, self.lineWidth / 2.0f);
    
    // 6
    CGContextMoveToPoint(context, selfSize.width - self.lineWidth / 2.0f, self.lineWidth / 2.0f);
    
    CGContextAddLineToPoint(context, selfSize.width - self.lineWidth / 2.0f, self.lineLenght);
    
    // 7
    CGContextMoveToPoint(context, selfSize.width - self.lineWidth / 2.0f, selfSize.height);
    
    CGContextAddLineToPoint(context, selfSize.width - self.lineWidth / 2.0f, selfSize.height - self.lineLenght);
    
    // 8
    CGContextMoveToPoint(context, selfSize.width - self.lineWidth / 2.0f, selfSize.height - self.lineWidth / 2.0f);
    
    CGContextAddLineToPoint(context, selfSize.width - self.lineLenght, selfSize.height - self.lineWidth / 2.0f);
    
    // cross
    if (self.showCross) {
        
        CGContextMoveToPoint(context, selfSize.width / 2.0f, selfSize.height / 2.0f - self.lineLenght / 2.0f);
        
        CGContextAddLineToPoint(context, selfSize.width / 2.0f, selfSize.height / 2.0f + self.lineLenght / 2.0f);
        
        CGContextMoveToPoint(context, selfSize.width / 2.0f - self.lineLenght / 2.0f, selfSize.height / 2.0f);
        
        CGContextAddLineToPoint(context, selfSize.width / 2.0f + self.lineLenght / 2.0f, selfSize.height / 2.0f);
    }
    
    CGContextStrokePath(context);
}

#pragma mark -
#pragma mark Setters

- (void)setShowCross:(BOOL)showCross {
    _showCross = showCross;
    [self setNeedsDisplay];
}


#pragma mark -
#pragma mark Getters

- (CGFloat)lineLenght {
    return (self.frame.size.width < self.frame.size.height) ? self.frame.size.width / self.lineProportion : self.frame.size.height / self.lineProportion;
}

@end

// ======= VTSVideoButton =======

@interface VTSVideoButton ()

@property (nonatomic, strong) VTSDecorView *decorView;

@end

@implementation VTSVideoButton

#pragma mark -
#pragma mark Update UI for preview

- (void)startPreview {
    self.playerView.alpha = 1.0f;
    self.decorView.showCross = NO;
    [self.decorView setNeedsDisplay];
}

- (void)stopPreview {
    self.playerView.alpha = 3.0f;
    self.decorView.showCross = YES;
    [self.decorView setNeedsDisplay];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    
    self.playerView = [VTSPlayerView new];
    self.playerView.backgroundColor = [UIColor blackColor];
    self.playerView.alpha = 0.3f;
    [self addSubview:self.playerView];
    
    self.decorView = [VTSDecorView new];
    
    self.decorView.lineWidth = 8;
    self.decorView.lineProportion = 3.5f;
    self.decorView.showCross = YES;
    
    [self addSubview:self.decorView];
    
    [self setupDecorSubviewsSize];
}

- (void)setupDecorSubviewsSize {
    CGRect bounds = self.bounds;
    self.playerView.frame = CGRectMake(self.decorView.lineWidth / 2.0f,
                                       self.decorView.lineWidth / 2.0f,
                                       bounds.size.width - self.decorView.lineWidth,
                                       bounds.size.height - self.decorView.lineWidth);
    
    self.decorView.frame = bounds;
    
    [self.decorView setNeedsDisplay];
}

@end
