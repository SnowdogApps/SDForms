//
//  SDButtonField.m
//  SDForms
//
//  Created by Rafal Kwiatkowski on 28.08.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import "SDButtonField.h"
#import "SDButtonFormCell.h"

@implementation SDButtonField


- (SDFormCell *)cellForTableView:(UITableView *)tableView atIndex:(NSUInteger)index
{
    SDButtonFormCell *cell = (SDButtonFormCell *)[super cellForTableView:tableView atIndex:index];
    cell.titleLabel.text = self.title;
    return cell;
}

- (NSArray *)reuseIdentifiers {
    return @[kButtonCell];
}

@end
