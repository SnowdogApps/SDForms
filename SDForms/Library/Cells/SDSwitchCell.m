//
//  SDSwitchCell.m
//  SDForms
//
//  Created by Radoslaw Szeja on 14.01.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import "SDSwitchCell.h"

@implementation SDSwitchCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setField:(SDFormField *)field
{
    [super setField:field];
    self.titleLabel.text = field.title;
    [self.switchControl setOn:[field.value boolValue] animated:NO];
}

- (IBAction)switchValueChanged:(UISwitch *)switchView
{
    [self.field setValue:@(switchView.isOn) withCellRefresh:NO];
}

@end
