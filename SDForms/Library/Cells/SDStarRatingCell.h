//
//  SDStarRatingCell.h
//  SDForms
//
//  Created by Radoslaw Szeja on 27.02.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDStarRatingView.h"

static NSString * const kStarRatingCell = @"SDStarRatingCell";

@interface SDStarRatingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *starRatingViewContainer;
@property (strong, nonatomic) SDStarRatingView *starRatingView;
@end
