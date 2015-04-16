//
//  VTSBaseViewController+ShwAlertOK.h
//  VideoTransitionsSample
//
//  Created by Ruslan Shevtsov on 4/13/15.
//  Copyright (c) 2015 iQueSoft. All rights reserved.
//

#import "VTSBaseViewController.h"

@interface VTSBaseViewController (ShwAlertOK)

- (void)showAlertOKWithText:(NSString *)aTextString;

- (void)showAlertOKWithTitle:(NSString *)aTitleString message:(NSString *)aMessageString;

@end
