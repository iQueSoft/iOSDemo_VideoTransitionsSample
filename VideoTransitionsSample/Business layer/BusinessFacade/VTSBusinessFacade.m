//
//  VTSBusinessFacade.m
//  VideoTransitionsSample
//
//  Created by Ruslan Shevtsov on 4/13/15.
//  Copyright (c) 2015 iQueSoft. All rights reserved.
//

#import "VTSBusinessFacade.h"

// Frameworks
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

// Player
#import "VTSAutoReplayPlayer.h"

@interface VTSBusinessFacade ()

@property (copy) VTSExportMoviCompletionBlock exportMoviCompletionBlock;

// Preview transition
@property (nonatomic, strong) APLVideoEditor *previewTransitionEditor;

@end

@implementation VTSBusinessFacade

#pragma mark -
#pragma mark Singleton

+ (instancetype)sharedBusinessFacade {
    static VTSBusinessFacade *_sharedBusinessFacade = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedBusinessFacade = [VTSBusinessFacade new];
    });
    
    return _sharedBusinessFacade;
}

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.firstVideoPreviewPlayer   = [VTSAutoReplayPlayer new];
    self.secondVideoPreviewPlayer  = [VTSAutoReplayPlayer new];
    self.transitionPreviewPlayer   = [VTSAutoReplayPlayer new];
    
    self.previewTransitionEditor = [self buildVideoEditorWithURLs:@[[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"preview_video_1" ofType:@"mp4"]],
                                                                    [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"preview_video_2" ofType:@"mp4"]]]];
    
    return self;
}

#pragma mark -
#pragma mark Setters

- (void)setFirstVideoURL:(NSURL *)firstVideoURL {
    _firstVideoURL = firstVideoURL;
    
    [self.firstVideoPreviewPlayer pause];
    [self.firstVideoPreviewPlayer replaceCurrentItemWithPlayerItem:[AVPlayerItem playerItemWithURL:firstVideoURL]];
    [self.firstVideoPreviewPlayer play];
}

- (void)setSecondVideoURL:(NSURL *)secondVideoURL {
    _secondVideoURL = secondVideoURL;
    
    [self.secondVideoPreviewPlayer pause];
    [self.secondVideoPreviewPlayer replaceCurrentItemWithPlayerItem:[AVPlayerItem playerItemWithURL:secondVideoURL]];
    [self.secondVideoPreviewPlayer play];

}

- (void)setTransitionType:(VTSTransitionType)transitionType {
    _transitionType = transitionType;
    
    self.previewTransitionEditor.transitionType = _transitionType;
    
    [self.previewTransitionEditor buildCompositionObjectsForPreviewTransition:YES];
    
    AVPlayerItem *playerItem = [self.previewTransitionEditor playerItem];

    [self.transitionPreviewPlayer pause];
    [self.transitionPreviewPlayer replaceCurrentItemWithPlayerItem:playerItem];
    [self.transitionPreviewPlayer play];
}

#pragma mark -
#pragma mark @public

- (void)exportToMovieWithCompletion:(VTSExportMoviCompletionBlock)aCompletionBlock {
    
    if (self.firstVideoURL == nil || self.secondVideoURL == nil) {
        aCompletionBlock(NO, nil);
        return;
    }
    
    self.exportMoviCompletionBlock = aCompletionBlock;
    
    APLVideoEditor *editor = [self buildVideoEditorWithURLs:@[self.firstVideoURL, self.secondVideoURL]];
    
    __weak __typeof(self)weakSelf = self;
    
    editor.transitionType = self.transitionType;
    [editor buildCompositionObjects];
    
    AVAssetExportSession *session = [editor assetExportSessionWithPreset:AVAssetExportPreset1280x720];
    
    session.outputURL = [[FRSFileManager new] urlForVideo];
    session.outputFileType = AVFileTypeQuickTimeMovie;
    
    [session exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf exportCompleted:session];
        });
    }];
}

- (AVPlayer *)playerWithCurrentVideo {
    if (self.firstVideoURL == nil || self.secondVideoURL == nil) {
        return nil;
    }
    
    APLVideoEditor *editor = [self buildVideoEditorWithURLs:@[self.firstVideoURL, self.secondVideoURL]];

    editor.transitionType = self.transitionType;
    [editor buildCompositionObjects];
    
    AVPlayerItem *playerItem = [editor playerItem];
    
    AVPlayer *player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
    
    return player;
}

#pragma mark -
#pragma mark @private

- (void)exportCompleted:(AVAssetExportSession *)session {
    NSURL *outputURL = session.outputURL;
    
    if ( session.status != AVAssetExportSessionStatusCompleted ) {
        DDLogDebug(@"exportSession error:%@", session.error);
        [self reportError:session.error];
    }
    
    if ( session.status != AVAssetExportSessionStatusCompleted ) {
        self.exportMoviCompletionBlock(NO, nil);
        return;
    }
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeVideoAtPathToSavedPhotosAlbum:outputURL completionBlock:^(NSURL *assetURL, NSError *error) {
        if (error == NULL) {
            self.exportMoviCompletionBlock(YES, nil);
        } else {
            DDLogDebug(@"writeVideoToAssestsLibrary failed: %@", error);
            self.exportMoviCompletionBlock(NO, error);
            [self reportError:error];
        }
    }];
}

- (void)reportError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error localizedDescription]
                                                                message:[error localizedRecoverySuggestion]
                                                               delegate:nil
                                                      cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                      otherButtonTitles:nil];
            
            [alertView show];
        }
    });
}

#pragma mark -
#pragma mark Video editor builder

- (APLVideoEditor *)buildVideoEditorWithURLs:(NSArray *)anURLs {
    
    APLVideoEditor *videoEditor = [[APLVideoEditor alloc] init];
    
    AVURLAsset *firstPreviewAsset = [AVURLAsset assetWithURL:anURLs[0]];
    AVURLAsset *secondPreviewAsset = [AVURLAsset assetWithURL:anURLs[1]];
    
    NSMutableArray *clips = [NSMutableArray array];
    
    [clips addObject:firstPreviewAsset];
    [clips addObject:secondPreviewAsset];
    
    videoEditor.clips = clips;
    
    NSMutableArray *timeRanges = [NSMutableArray array];
    
    AVAssetTrack *videoTrack1 = [[firstPreviewAsset tracksWithMediaType:AVMediaTypeVideo] lastObject];
    [timeRanges addObject:[NSValue valueWithCMTimeRange:videoTrack1.timeRange]];
    AVAssetTrack *videoTrack2 = [[secondPreviewAsset tracksWithMediaType:AVMediaTypeVideo] lastObject];
    [timeRanges addObject:[NSValue valueWithCMTimeRange:videoTrack2.timeRange]];
    
    videoEditor.clipTimeRanges = timeRanges;
    
    return videoEditor;
}

@end
