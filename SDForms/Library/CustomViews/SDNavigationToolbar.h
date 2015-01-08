//
//  SDNavigationToolbar.h
//  SDForms
//
//  Created by Radoslaw Szeja on 15.01.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SDNavigationToolbar;
@protocol SDNavigationToolbarDelegate <NSObject>
- (void)moveToPrevious;
- (void)moveToNext;
- (void)hideKeyboard;
@end

static NSString * const kSDNavigationToolbar = @"SDNavigationToolbar";

@interface SDNavigationToolbar : UIToolbar
@property (weak, nonatomic) id<SDNavigationToolbarDelegate> toolbarDelegate;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *previousButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *hideButton;
@end
