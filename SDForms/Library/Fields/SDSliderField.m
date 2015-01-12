//
//  SDSliderField.m
//  SDForms
//
//  Created by Rafal Kwiatkowski on 26.08.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import "SDSliderField.h"
#import "SDSliderCell.h"

@interface SDSliderField ()

@end

@implementation SDSliderField

- (id)init
{
    self = [super init];
    if (self) {
        self.min = 0.0;
        self.max = 10.0;
        self.step = 1.0;
    }
    return self;
}

- (NSArray *)reuseIdentifiers {
    return @[kSliderCell];
}

- (NSArray *)cellHeights {
    return @[@88.0];
}

- (SDFormCell *)cellForTableView:(UITableView *)tableView atIndex:(NSUInteger)index
{
    SDFormCell *cell = [super cellForTableView:tableView atIndex:index];
    
    if ([cell isKindOfClass:[SDSliderCell class]]) {
        SDSliderCell *sliderCell = (SDSliderCell *)cell;
        sliderCell.slider.minimumValue = self.min;
        sliderCell.slider.maximumValue = self.max;
        sliderCell.titleLabel.text = self.title;
        sliderCell.valueLabel.text = self.formattedValue;
        [sliderCell.slider setValue:[self.value floatValue] animated:YES];
    }
    
    return cell;
}

@end
