//
//  SDStarRatingCell.m
//  SDForms
//
//  Created by Radoslaw Szeja on 27.02.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import "SDStarRatingCell.h"

@implementation SDStarRatingCell

- (SDStarRatingView *)starRatingView
{
    if (_starRatingView == nil) {
        _starRatingView = [[[NSBundle mainBundle] loadNibNamed:@"SDStarRatingView" owner:self options:nil] firstObject];
        [_starRatingView setActive:YES];
        [_starRatingView setUserInteractionEnabled:NO];
        [self.starRatingViewContainer addSubview:_starRatingView];
    }
    
    return _starRatingView;
}

- (void)setStarRatingView:(SDStarRatingView *)starRatingView
{
    if (_starRatingView != starRatingView) {
        [_starRatingView removeFromSuperview];
        _starRatingView = starRatingView;
        [self.starRatingViewContainer addSubview:self.starRatingView];
    }
}

@synthesize starRatingView = _starRatingView;

@end
