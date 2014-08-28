//
//  SDMultilineTextFormField.m
//  SDForms
//
//  Created by Rafal Kwiatkowski on 26.08.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import "SDMultilineTextField.h"
#import "SDTextViewCell.h"

@implementation SDMultilineTextField

- (id)init
{
    self = [super init];
    if (self) {
        self.textViewHeight = 0.0;
    }
    return self;
}

- (void)registerCellsInTableView:(UITableView *)tableView
{
    [tableView registerNib:[UINib nibWithNibName:kTextViewCell bundle:self.defaultBundle] forCellReuseIdentifier:kTextViewCell];
    self.reuseIdentifiers = @[kTextViewCell];
    
    if (self.textViewHeight > 0.0) {
        self.cellHeights = @[@(self.textViewHeight)];
    } else {
        self.cellHeights = @[@88.0];
    }
}

@end
