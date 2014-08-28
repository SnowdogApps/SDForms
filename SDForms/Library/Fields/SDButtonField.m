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
    [tableView registerNib:[UINib nibWithNibName:kButtonCell bundle:nil] forCellReuseIdentifier:kButtonCell];
    self.reuseIdentifiers = @[kButtonCell];
}

@end
