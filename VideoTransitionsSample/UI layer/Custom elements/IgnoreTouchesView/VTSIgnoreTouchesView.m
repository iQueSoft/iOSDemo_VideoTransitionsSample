//
//  VTSIgnoreTouchesView.m
//  VideoTransitionsSample
//
//  Created by Ruslan Shevtsov on 4/15/15.
//  Copyright (c) 2015 iQueSoft. All rights reserved.
//

#import "VTSIgnoreTouchesView.h"

@interface VTSIgnoreTouchesView ()

@end

@implementation VTSIgnoreTouchesView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    return self.superview;
}

@end
