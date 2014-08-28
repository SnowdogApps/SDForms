//
//  SDSwitchField.m
//  SDForms
//
//  Created by Rafal Kwiatkowski on 28.08.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import "SDSwitchField.h"
#import "SDSwitchCell.h"

@implementation SDSwitchField

- (void)registerCellsInTableView:(UITableView *)tableView
{
    [tableView registerNib:[UINib nibWithNibName:kSwitchCell bundle:nil] forCellReuseIdentifier:kSwitchCell];
    self.reuseIdentifiers = @[kSwitchCell];
}

@end
