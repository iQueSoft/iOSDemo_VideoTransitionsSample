//
//  VTSBusinessFacade.h
//  VideoTransitionsSample
//
//  Created by Ruslan Shevtsov on 4/13/15.
//  Copyright (c) 2015 iQueSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

// Video processor
#import "APLVideoEditor.h"

@class AVPlayerItem;
@class AVURLAsset;
@class AVPlayer;

typedef void (^VTSExportMoviCompletionBlock)(BOOL isDone, NSError *anError);

@interface VTSBusinessFacade : NSObject

@property (nonatomic, strong) NSURL *firstVideoURL;
@property (nonatomic, strong) NSURL *secondVideoURL;

@property (nonatomic, assign) VTSTransitionType		transitionType;

@property (nonatomic, strong) AVPlayer *firstVideoPreviewPlayer;
@property (nonatomic, strong) AVPlayer *secondVideoPreviewPlayer;
@property (nonatomic, strong) AVPlayer *transitionPreviewPlayer;

#pragma mark -
#pragma mark Singleton

+ (instancetype)sharedBusinessFacade;

#pragma mark -
#pragma mark @publick

- (void)exportToMovieWithCompletion:(VTSExportMoviCompletionBlock)aCompletionBlock;

- (AVPlayer *)playerWithCurrentVideo;

@end
