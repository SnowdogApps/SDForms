//
//  SDQuantityTypeCell.m
//  SDForms
//
//  Created by Rafal Kwiatkowski on 20.05.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import "SDSliderFormCell.h"

@implementation SDSliderFormCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)sliderValueChanged:(UISlider*)slider {
    float value = [self roundValue:slider.value];
    [slider setValue:value animated:NO];
    self.field.value = @(value);
}

- (float) roundValue:(float)value {
    return roundf(value / self.field.step) * self.field.step;
}

- (void)setField:(SDSliderField *)field
{
    [super setField:field];
}

@dynamic field;

@end
