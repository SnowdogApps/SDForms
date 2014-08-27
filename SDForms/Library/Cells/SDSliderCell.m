//
//  SDQuantityTypeCell.m
//  SDForms
//
//  Created by Rafal Kwiatkowski on 20.05.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import "SDSliderCell.h"

@implementation SDSliderCell

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
    self.titleLabel.text = self.field.title;
    self.valueLabel.text = self.field.formattedValue;
    self.slider.minimumValue = field.min;
    self.slider.maximumValue = field.max;
    [self.slider setValue:[field.value floatValue] animated:YES];

}

@end
