//
//  SDTextViewCell.m
//  SDForms
//
//  Created by Radoslaw Szeja on 16.03.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import "SDTextViewCell.h"

@implementation SDTextViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.textView.delegate = self;
    self.responders = @[self.textView];
}

- (void)markCorrectValue
{
    [self.layer setBorderColor:[UIColor clearColor].CGColor];
    [self.layer setBorderWidth:0.0f];
}

- (void)markWrongValue
{
    [self.layer setBorderColor:[UIColor redColor].CGColor];
    [self.layer setBorderWidth:1.0f];
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputAccessoryViewForCell:)]) {
        textView.inputAccessoryView = [self.delegate inputAccessoryViewForCell:self];
    }
    return YES;
}

- (void)textViewDidBeginEditing:(SDTextView *)textView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(formCell:didActivateResponder:)]) {
        [self.delegate formCell:self didActivateResponder:textView];
    }
}

- (void)textViewDidEndEditing:(SDTextView *)textView
{
    self.field.value = textView.text;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(formCell:didDeactivateResponder:)]) {
        [self.delegate formCell:self didDeactivateResponder:textView];
    }
}

- (void)setField:(SDFormField *)field
{
    [super setField:field];
}


@end
