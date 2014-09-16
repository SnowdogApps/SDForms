//
//  SDButtonField.m
//  SDForms
//
//  Created by Rafal Kwiatkowski on 28.08.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import "SDButtonField.h"
#import "SDButtonCell.h"

@implementation SDButtonField

- (void)registerCellsInTableView:(UITableView *)tableView
{
    [tableView registerNib:[UINib nibWithNibName:kButtonCell bundle:self.defaultBundle] forCellReuseIdentifier:kButtonCell];
    self.reuseIdentifiers = @[kButtonCell];
}

- (SDFormCell *)cellForTableView:(UITableView *)tableView atIndex:(NSUInteger)index
{
    SDButtonCell *cell = (SDButtonCell *)[super cellForTableView:tableView atIndex:index];
    cell.titleLabel.text = self.title;
    return cell;
}

@end
