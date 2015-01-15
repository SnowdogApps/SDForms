//
//  SDTextViewCell.h
//  SDForms
//
//  Created by Radoslaw Szeja on 16.03.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDFormCell.h"
#import "SDFormTextView.h"
#import "SDMultilineTextField.h"

static NSString * const kTextViewCell = @"SDTextViewFormCell";

@interface SDTextViewFormCell : SDFormCell <UITextViewDelegate>

@property (nonatomic, weak) SDMultilineTextField *field;
@property (weak, nonatomic) IBOutlet SDFormTextView *textView;
@property (strong, nonatomic) NSString *placeHolder;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIFont *textFont;
@property (nonatomic, strong) NSString *text;
@property (nonatomic) BOOL editable;
@property (nonatomic) BOOL selectable;
@property (nonatomic) BOOL placeholderVisible;

- (void)markWrongValue;
- (void)markCorrectValue;

@end
