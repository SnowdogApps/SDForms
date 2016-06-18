//
//  SDTextViewCell.m
//  SDForms
//
//  Created by Radoslaw Szeja on 16.03.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import "SDTextViewFormCell.h"

@interface SDTextViewFormCell ()

@end


@implementation SDTextViewFormCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.textView.delegate = self;
    self.responders = @[self.textView];
    self.placeholderVisible = YES;
    self.editable = YES;
    self.selectable = YES;
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

- (void)textViewDidBeginEditing:(SDFormTextView *)textView
{
    if (self.placeholderVisible) {
        self.placeholderVisible = NO;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(formCell:didActivateResponder:)]) {
        [self.delegate formCell:self didActivateResponder:textView];
    }
}

- (void)textViewDidEndEditing:(SDFormTextView *)textView
{
    if (textView.attributedText.length == 0) {
        self.placeholderVisible = YES;
    }
    
    if (!self.placeholderVisible) {
        self.field.value = textView.text;
    } else {
        self.field.value = nil;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(formCell:didDeactivateResponder:)]) {
        [self.delegate formCell:self didDeactivateResponder:textView];
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (!self.placeholderVisible) {
        [self.field setValue:textView.text withCellRefresh:NO];
    } else {
        self.field.value = nil;
    }
}

- (void)setField:(SDFormField *)field
{
    [super setField:field];
}

- (void)setPlaceholderVisible:(BOOL)placeholderVisible
{
    _placeholderVisible = placeholderVisible;
    self.field.placeholderVisible = placeholderVisible;
    
    self.textView.editable = YES;
    self.textView.selectable = YES;
    
    if (placeholderVisible) {
        self.textView.attributedText = [[NSAttributedString alloc] initWithString:(self.placeHolder ? self.placeHolder : @"") attributes:@{NSFontAttributeName : self.textFont, NSForegroundColorAttributeName : [UIColor lightGrayColor]}];
    } else {
        self.textView.textColor = self.textColor;
        self.textView.font = self.textFont;
        self.textView.text = nil;
    }
    
    self.textView.editable = self.editable;
    self.textView.selectable = self.selectable;
}

- (NSString *)text
{
    return self.textView.text;
}

- (void)setText:(NSString *)text
{
    if (text.length > 0) {
        self.placeholderVisible = NO;
        self.textView.editable = YES;
        self.textView.selectable = YES;
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName: self.textFont, NSForegroundColorAttributeName: self.textColor}];
        self.textView.attributedText = attrString;
        self.textView.editable = self.editable;
        self.textView.selectable = self.selectable;
    } else {
        self.textView.textColor = self.textColor;
        self.textView.font = self.textFont;
        self.textView.attributedText = nil;
        self.placeholderVisible = YES;
    }
}

- (UIFont *)textFont
{
    if (!_textFont) {
        _textFont = [UIFont systemFontOfSize:14.0];
    }
    return _textFont;
}

- (UIColor *)textColor
{
    if (!_textColor) {
        _textColor = [UIColor darkTextColor];
    }
    return _textColor;
}

- (void)setEditable:(BOOL)editable
{
    _editable = editable;
    if (editable) {
        self.responders = @[self.textView];
    } else {
        self.responders = nil;
    }
}

@dynamic field;

@end
