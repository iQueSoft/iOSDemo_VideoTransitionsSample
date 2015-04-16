//
//  VTSBaseViewController+ShwAlertOK.m
//  VideoTransitionsSample
//
//  Created by Ruslan Shevtsov on 4/13/15.
//  Copyright (c) 2015 iQueSoft. All rights reserved.
//

#import "VTSBaseViewController+ShwAlertOK.h"

// Strings
#define kOKString NSLocalizedString(@"OK", nil)

@implementation VTSBaseViewController (ShwAlertOK)

- (void)showAlertOKWithText:(NSString *)aTextString {
    [self showAlertOKWithTitle:aTextString message:nil];
}

- (void)showAlertOKWithTitle:(NSString *)aTitleString message:(NSString *)aMessageString {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:aTitleString message:aMessageString preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:kOKString style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
