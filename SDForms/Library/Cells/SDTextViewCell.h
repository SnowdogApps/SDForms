//
//  SDTextViewCell.h
//  SDForms
//
//  Created by Radoslaw Szeja on 16.03.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDFormCell.h"
#import "SDTextView.h"

static NSString * const kTextViewCell = @"SDTextViewCell";

@interface SDTextViewCell : SDFormCell <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet SDTextView *textView;

- (void)markWrongValue;
- (void)markCorrectValue;

@end
