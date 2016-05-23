//
//  SDRatingStarsFormCell.m
//  SDForms
//
//  Created by Tim Kelly on 5/20/16.
//  Copyright © 2016 Snowdog sp. z o.o. All rights reserved.
//

#import "SDRatingStarsFormCell.h"

@implementation SDRatingStarsFormCell

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
}


@end
