//
//  SDChooseGoalsCell.m
//  SDForms
//
//  Created by Rafal Kwiatkowski on 21.01.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import "SDButtonCell.h"

@implementation SDButtonCell

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

@end
