//
//  SDDatePickerCell.m
//  SDForms
//
//  Created by Radoslaw Szeja on 13.01.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import "SDDatePickerCell.h"

@implementation SDDatePickerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

#pragma mark - Setters

- (void)setField:(SDFormField *)field
{
    [super setField:field];
    if ([field.value isKindOfClass:[NSDate class]]) {
        [self.datePicker setDate:field.value animated:NO];
    }
}

- (IBAction)dateChanged:(id)sender {
    self.field.value = self.datePicker.date;
}

@end
