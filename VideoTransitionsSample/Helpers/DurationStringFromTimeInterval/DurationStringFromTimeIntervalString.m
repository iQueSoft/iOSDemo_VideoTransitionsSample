//
//  DurationStringFromTimeInterval.m
//  VideoRecordSample
//
//  Created by Ruslan Shevtsov on 4/2/15.
//  Copyright (c) 2015 iQueSoft rights reserved.
//

#import "DurationStringFromTimeInterval.h"

NSString * const kTimeZeroString = @"0:00";

NSString* DurationFromTimeInterval(double duration) {
    if (duration == 0.0) {
        return kTimeZeroString;
    }
    NSString *timeIntervalString = nil;
    
    int minutes = (int)(duration / 60);
    int seconds = (int)(((int)duration) % 60);
    
    NSString *secondsStrong = nil;
    
    if (seconds >= 10) {
        secondsStrong = [NSString stringWithFormat:@"%d", seconds];
    } else {
        secondsStrong = [NSString stringWithFormat:@"0%d", seconds];
    }
    
    timeIntervalString = [NSString stringWithFormat:@"%d:%@", minutes, secondsStrong];
    
    return timeIntervalString;
}
