//
//  SDMutableStarRatingCell.h
//  SDForms
//
//  Created by Radoslaw Szeja on 28.02.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDStarRatingCell.h"

static NSString * const kMutableStarRatingCell = @"SDMutableStarRatingCell";

@interface SDMutableStarRatingCell : SDStarRatingCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UISwitch *switchControl;
@end