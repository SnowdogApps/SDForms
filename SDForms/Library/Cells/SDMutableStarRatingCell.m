//
//  SDMutableStarRatingCell.m
//  SDForms
//
//  Created by Radoslaw Szeja on 28.02.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import "SDMutableStarRatingCell.h"

@implementation SDMutableStarRatingCell

- (IBAction)switchValueChanged:(UISwitch *)sender
{
    if (NO == sender.on) {
        [self.starRatingView setNumberOfFullStars:@0];
    }
    
    [self.starRatingView setUserInteractionEnabled:sender.on];
}

- (SDStarRatingView *)starRatingView
{
    _starRatingView = [super starRatingView];
    [_starRatingView setUserInteractionEnabled:self.switchControl.on];
    [_starRatingView setActive:self.switchControl.on];
    return _starRatingView;
}

-(void)setStarRatingView:(SDStarRatingView *)starRatingView
{
    [super setStarRatingView:starRatingView];
    [starRatingView setUserInteractionEnabled:self.switchControl.on];
    [_starRatingView setActive:self.switchControl.on];
}

@synthesize starRatingView = _starRatingView;

@end
