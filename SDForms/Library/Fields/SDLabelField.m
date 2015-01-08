//
//  SDButtonField.m
//  SDForms
//
//  Created by Rafal Kwiatkowski on 27.08.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import "SDLabelField.h"
#import "SDLabelCell.h"

@implementation SDLabelField

- (void)registerCellsInTableView:(UITableView *)tableView
{
    [tableView registerNib:[UINib nibWithNibName:kLabelCell bundle:self.defaultBundle] forCellReuseIdentifier:kLabelCell];
    self.reuseIdentifiers = @[kLabelCell];
}

- (SDFormCell *)cellForTableView:(UITableView *)tableView atIndex:(NSUInteger)index
{
    SDLabelCell *cell = (SDLabelCell *)[super cellForTableView:tableView atIndex:index];
    cell.titleLabel.text = self.title;
    cell.valueLabel.text = self.formattedValue;
    return cell;
}

@end
