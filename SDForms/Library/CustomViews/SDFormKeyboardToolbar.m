//
//  SDNavigationToolbar.m
//  SDForms
//
//  Created by Radoslaw Szeja on 15.01.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import "SDFormKeyboardToolbar.h"
#import "UIColor+HexColor.h"

@implementation SDFormKeyboardToolbar

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setTintColor:[UIColor colorWithHex:@"#0076a3"]];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.previousButton setTitle:NSLocalizedString(@"Previous", nil)];
    [self.nextButton setTitle:NSLocalizedString(@"Next", nil)];
    [self.hideButton setTitle:NSLocalizedString(@"Hide", nil)];
}

#pragma mark - Target actions

- (IBAction)hideKeyboard:(id)sender
{
    if ([self.toolbarDelegate respondsToSelector:@selector(hideKeyboard)]) {
        [self.toolbarDelegate hideKeyboard];
    }
}

- (IBAction)moveToNext:(id)sender
{
    [self updateButtons];
    if ([self.toolbarDelegate respondsToSelector:@selector(moveToNext)]) {
        [self.toolbarDelegate moveToNext];
    }
}


- (IBAction)moveToPrevious:(id)sender
{
    [self updateButtons];
    if ([self.toolbarDelegate respondsToSelector:@selector(moveToPrevious)]) {
        [self.toolbarDelegate moveToPrevious];
    }
}

- (void)updateButtons
{
    [self.previousButton setEnabled:YES];
    [self.nextButton setEnabled:YES];
}

@end
