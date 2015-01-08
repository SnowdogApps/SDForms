//
//  SDBigMutableStarRatingCell.m
//  SDForms
//
//  Created by Radoslaw Szeja on 14.03.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import "SDBigMutableStarRatingCell.h"

@implementation SDBigMutableStarRatingCell

- (void)awakeFromNib
{
    self.starRatingView = [[[NSBundle mainBundle] loadNibNamed:@"SDBigStarRatingView" owner:self options:nil] lastObject];
    [self.starRatingView setUserInteractionEnabled:YES];
    [self.starRatingView setActive:YES];
    [self.starRatingView setNumberOfFullStars:@1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setStarRatingView:(SDBigStarRatingView *)starRatingView
{
    if (_starRatingView != starRatingView) {
        [_starRatingView removeFromSuperview];
        _starRatingView = starRatingView;
        [self.contentView addSubview:_starRatingView];
    }
}

- (void)setInteractionEnabled:(BOOL)interactionEnabled
{
    self.starRatingView.userInteractionEnabled = interactionEnabled;
}

- (BOOL)interactionEnabled
{
    return self.starRatingView.userInteractionEnabled;
}

@end
