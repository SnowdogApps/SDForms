//
//  SDSwitchField.m
//  SDForms
//
//  Created by Rafal Kwiatkowski on 28.08.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import "SDSwitchField.h"
#import "SDSwitchFormCell.h"

@implementation SDSwitchField

- (NSArray *)reuseIdentifiers {
    return @[kSwitchCell];
}

- (SDFormCell *)cellForTableView:(UITableView *)tableView atIndex:(NSUInteger)index
{
    SDSwitchFormCell *cell = (SDSwitchFormCell *)[super cellForTableView:tableView atIndex:index];
    cell.titleLabel.text = self.title;
    [cell.switchControl setOn:[self.value boolValue] animated:NO];
    return cell;
}

@end
