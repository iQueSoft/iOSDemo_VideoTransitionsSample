//
//  VTSMainViewController.m
//  VideoTransitionsSample
//
//  Created by Ruslan Shevtsov on 4/10/15.
//  Copyright (c) 2015 iQueSoft. All rights reserved.
//

#import "VTSMainViewController.h"

// Frameworks
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>

// Business facade
#import "VTSBusinessFacade.h"

// UI
#import "VTSVideoButton.h"
#import "UIAlertController+Blocks.h"
#import "UIImagePickerController+DelegateBlocks.h"
#import "MBProgressHUD.h"
#import "VTSBaseViewController+ShwAlertOK.h"
#import "VTSTransitionButton.h"
#import "VTSTransitionsViewController.h"
#import "VTSPlayerView.h"
#import "VTSPlayerViewController.h"

// Strings
#define kErrorString NSLocalizedString(@"Error!", nil)
#define kProcessingVideoString NSLocalizedString(@"Video processing...", nil)
#define kSaveCompleteString NSLocalizedString(@"Save complete!", nil)
#define kRecordVideoFirstString NSLocalizedString(@"You should record or choose a video first.", nil)

@interface VTSMainViewController ()

@property (weak, nonatomic) IBOutlet VTSVideoButton *firstVideoButton;
@property (weak, nonatomic) IBOutlet VTSVideoButton *secondVideoButton;
@property (weak, nonatomic) IBOutlet VTSTransitionButton *transitionButton;

@property (weak, nonatomic) IBOutlet UIView *transitionsView;
@property (weak, nonatomic) IBOutlet UIView *interfaceContainerView;

@end

@implementation VTSMainViewController

#pragma mark -
#pragma mark Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[VTSBusinessFacade sharedBusinessFacade] setTransitionType:VTSTransitionDefault];
    
    self.firstVideoButton.playerView.player = [VTSBusinessFacade sharedBusinessFacade].firstVideoPreviewPlayer;
    self.secondVideoButton.playerView.player = [VTSBusinessFacade sharedBusinessFacade].secondVideoPreviewPlayer;
    self.transitionButton.playerView.player = [VTSBusinessFacade sharedBusinessFacade].transitionPreviewPlayer;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hidePlayerViewController:)
                                                 name:kHidePlayerViewNotificationString
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[VTSBusinessFacade sharedBusinessFacade].firstVideoPreviewPlayer play];
    [[VTSBusinessFacade sharedBusinessFacade].secondVideoPreviewPlayer play];
    [[VTSBusinessFacade sharedBusinessFacade].transitionPreviewPlayer play];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[VTSBusinessFacade sharedBusinessFacade].firstVideoPreviewPlayer pause];
    [[VTSBusinessFacade sharedBusinessFacade].secondVideoPreviewPlayer pause];
    [[VTSBusinessFacade sharedBusinessFacade].transitionPreviewPlayer pause];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -
#pragma mark Orientation

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

#pragma mark -
#pragma mark IBActions

- (IBAction)chooseFirstVideoAction:(VTSVideoButton *)sender {
    [self chooseVideoFromVideoButton:sender];
}

- (IBAction)chooseSecondVideoButton:(VTSVideoButton *)sender {
    [self chooseVideoFromVideoButton:sender];
}

- (IBAction)saveVideoAction:(id)sender {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = kProcessingVideoString;
    
    [[VTSBusinessFacade sharedBusinessFacade] exportToMovieWithCompletion:^(BOOL isDone, NSError *anError) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isDone == NO) {
            [self showAlertOKWithTitle:kErrorString message:kRecordVideoFirstString];
        } else {
            [self showAlertOKWithText:kSaveCompleteString];
        }
    }];
}

- (IBAction)showTransitionsViewAction:(id)sender {
    [self showTransitionsListView];
}

#pragma mark -
#pragma mark Choose video

- (void)chooseVideoFromVideoButton:(VTSVideoButton *)videoButton {
    
    static NSString * const kGalleryTitleString = @"Gallery";
    static NSString * const kCameraTitleString = @"Camera";
    
    __weak __typeof(self)weakSelf = self;
    
    UIAlertControllerCompletionBlock tapBlock = ^(UIAlertController *controller,
                                                  UIAlertAction *action,
                                                  NSInteger buttonIndex) {
        if ([action.title isEqualToString:kGalleryTitleString]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf showImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary fromVideoButton:videoButton];
            });
        } else if ([action.title isEqualToString:kCameraTitleString]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf showImagePickerWithSourceType:UIImagePickerControllerSourceTypeCamera fromVideoButton:videoButton];
            });
        }
    };
    
    [UIAlertController showActionSheetInViewController:self
                                             withTitle:@"Choose video"
                                               message:nil
                                     cancelButtonTitle:@"Cancel"
                                destructiveButtonTitle:nil
                                     otherButtonTitles:@[kGalleryTitleString, kCameraTitleString]
                    popoverPresentationControllerBlock:nil
                                              tapBlock:tapBlock];
}

- (void)showImagePickerWithSourceType:(UIImagePickerControllerSourceType)sourceType
                      fromVideoButton:(VTSVideoButton *)videoButton {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.videoQuality = UIImagePickerControllerQualityTypeIFrame1280x720;
    picker.allowsEditing = YES;
    picker.sourceType = sourceType;
    picker.mediaTypes = @[(NSString *)kUTTypeMovie];
    
    [picker useBlocksForDelegate];
    
    __weak VTSVideoButton *weakVideoButton = videoButton;
    __weak __typeof(self)weakSelf = self;
    
    [picker onDidFinishPickingMediaWithInfo:^(UIImagePickerController *picker, NSDictionary *info) {
        DDLogDebug(@"info %@", info);
        
        if (weakVideoButton == weakSelf.firstVideoButton) {
            [VTSBusinessFacade sharedBusinessFacade].firstVideoURL = info[UIImagePickerControllerMediaURL];
            [weakSelf.firstVideoButton startPreview];
        } else if (weakVideoButton == weakSelf.secondVideoButton) {
            [VTSBusinessFacade sharedBusinessFacade].secondVideoURL = info[UIImagePickerControllerMediaURL];
            [weakSelf.secondVideoButton startPreview];
        }

        [picker dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [self presentViewController:picker animated:YES completion:NULL];
}

#pragma mark -
#pragma mark Transitions list

- (void)showTransitionsListView {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hideTransitionsListView:)
                                                 name:kHideTransitionsListViewNotificationString
                                               object:nil];
    
    self.interfaceContainerView.hidden = YES;
    self.transitionsView.hidden = NO;
}

- (void)hideTransitionsListView {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kHideTransitionsListViewNotificationString object:nil];
    
    self.transitionButton.playerView.player = [VTSBusinessFacade sharedBusinessFacade].transitionPreviewPlayer;
    
    self.transitionsView.hidden = YES;
    self.interfaceContainerView.hidden = NO;
}

#pragma mark -
#pragma mark Notifications

- (void)hideTransitionsListView:(NSNotification *)aNotification {
    [self hideTransitionsListView];
}

- (void)hidePlayerViewController:(NSNotification *)aNotification {
    VTSPlayerViewController *playerViewController = aNotification.object;
    [playerViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
