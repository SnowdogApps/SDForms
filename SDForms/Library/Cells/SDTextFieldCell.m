//
//  SDTextFieldCell.m
//  SDForms
//
//  Created by Rafal Kwiatkowski on 18.08.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import "SDTextFieldCell.h"

@implementation SDTextFieldCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.textField.delegate = self;
    self.responders = @[self.textField];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - SDTextField delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputAccessoryViewForCell:)]) {
        textField.inputAccessoryView = [self.delegate inputAccessoryViewForCell:self];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(formCell:didActivateResponder:)]) {
        [self.delegate formCell:self didActivateResponder:textField];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.field.valueType == SDFormFieldValueTypeText) {
        self.field.value = textField.text;
    } else if (self.field.valueType == SDFormFieldValueTypeDouble || self.field.valueType == SDFormFieldValueTypeInt) {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        self.field.value = [formatter numberFromString:textField.text];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(formCell:didDeactivateResponder:)]) {
        [self.delegate formCell:self didDeactivateResponder:textField];
    }
}

- (void)setField:(SDFormField *)field
{
    [super setField:field];
    if (field.valueType == SDFormFieldValueTypeText) {
        self.textField.text = field.value;
    } else if (field.valueType == SDFormFieldValueTypeDouble || field.valueType == SDFormFieldValueTypeInt) {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [formatter setPositiveFormat:@"####.##"];
        self.textField.text = [formatter stringFromNumber:field.value];
    }
}

@end
