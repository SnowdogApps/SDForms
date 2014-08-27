//
//  SDPollOtherDataCell.m
//  SDForms
//
//  Created by Radoslaw Szeja on 10.01.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import "SDTextFieldWithLabelCell.h"

@implementation SDTextFieldWithLabelCell

- (void)setField:(SDFormField <SDTextFieldDelegate> *)field
{
    [super setField:field];
    self.titleLabel.text = field.title;
}

@end
