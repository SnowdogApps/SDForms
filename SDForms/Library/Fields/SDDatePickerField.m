//
//  SDDatePickerFormField.m
//  SDForms
//
//  Created by Rafal Kwiatkowski on 18.08.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import "SDDatePickerField.h"
#import "SDLabelCell.h"
#import "SDDatePickerCell.h"

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

- (void)registerCellsInTableView:(UITableView *)tableView
{
    [tableView registerNib:[UINib nibWithNibName:kLabelCell bundle:nil] forCellReuseIdentifier:kLabelCell];
    [tableView registerNib:[UINib nibWithNibName:kDatePickerCell bundle:nil] forCellReuseIdentifier:kDatePickerCell];
    self.reuseIdentifiers = @[kLabelCell, kDatePickerCell];
    self.cellHeights = @[@44.0, @162.0];
}

- (SDFormCell *)cellForTableView:(UITableView *)tableView atIndex:(NSUInteger)index
{
    SDFormCell *cell = [super cellForTableView:tableView atIndex:index];
    
    if ([cell isKindOfClass:[SDDatePickerCell class]]) {
        SDDatePickerCell *datePickerCell = (SDDatePickerCell *)cell;
        if (self.timeZone) {
            datePickerCell.datePicker.timeZone = self.timeZone;
        }
        if (self.datePickerMode) {
            datePickerCell.datePicker.datePickerMode = self.datePickerMode;
        }
    }
    
    return cell;
}

- (NSString *)formattedValue
{
    if (self.formatDelegate && [self.formatDelegate respondsToSelector:@selector(formattedValueForField:)]) {
        return [self.formatDelegate formattedValueForField:self];
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
