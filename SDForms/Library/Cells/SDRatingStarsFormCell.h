//
//  SDRatingStarsFormCell.h
//  SDForms
//
//  Created by Tim Kelly on 5/20/16.
//  Copyright © 2016 Snowdog sp. z o.o. All rights reserved.
//

#import "SDFormCell.h"
#import <HCSStarRatingView/HCSStarRatingView.h>

static NSString * const kStarRatingCell = @"SDRatingStarsFormCell";

@interface SDRatingStarsFormCell : SDFormCell

@property (weak, nonatomic) IBOutlet HCSStarRatingView *ratingStars;


@end
