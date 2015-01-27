//
//  SDDatePickerFormField.m
//  SDForms
//
//  Created by Rafal Kwiatkowski on 18.08.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import "SDDatePickerField.h"
#import "SDLabelFormCell.h"
#import "SDDatePickerFormCell.h"

static NSString * const kDefaultDateFormat = @"yyyy-MM-dd HH:mm:ss";

@implementation SDDatePickerField

@synthesize hasPicker = _hasPicker;

- (id)init
{
    self = [super init];
    if (self) {
        _hasPicker = YES;
        _datePickerMode = UIDatePickerModeDateAndTime;
    }
    return self;
}

- (NSArray *)reuseIdentifiers {
    return @[kLabelCell, kDatePickerCell];
}

- (NSArray *)cellHeights {
    return @[@44.0, @162.0];
}

- (SDFormCell *)cellForTableView:(UITableView *)tableView atIndex:(NSUInteger)index
{
    SDFormCell *cell = [super cellForTableView:tableView atIndex:index];
    if ([cell isKindOfClass:[SDLabelFormCell class]]) {
        SDLabelFormCell *labelCell = (SDLabelFormCell *)cell;
        labelCell.titleLabel.text = self.title;
        labelCell.valueLabel.text = self.formattedValue;
    } else if ([cell isKindOfClass:[SDDatePickerFormCell class]]) {
        SDDatePickerFormCell *datePickerCell = (SDDatePickerFormCell *)cell;
        if (self.timeZone) {
            datePickerCell.datePicker.timeZone = self.timeZone;
        }
        
        datePickerCell.datePicker.datePickerMode = self.datePickerMode;
        
        if (self.value) {
            [datePickerCell.datePicker setDate:self.value animated:NO];
        }
    }
    
    return cell;
}

- (NSString *)formattedValue
{
    if (self.formatDelegate && [self.formatDelegate respondsToSelector:@selector(formattedValueForField:)]) {
        return [self.formatDelegate formattedValueForField:self];
    } else if (self.relatedObject && self.formattedValueKey) {
        return [self.relatedObject valueForKey:self.formattedValueKey];
    } else {
        if ([self.value isKindOfClass:[NSDate class]]) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            
            if (self.timeZone) {
                dateFormatter.timeZone = self.timeZone;
            }
            if (self.dateFormat) {
                dateFormatter.dateFormat = self.dateFormat;
            } else {
                dateFormatter.dateFormat = kDefaultDateFormat;
            }
            return [dateFormatter stringFromDate:self.value];
        }
        return [super formattedValue];
    }
}

@end
