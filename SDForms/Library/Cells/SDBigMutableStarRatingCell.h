//
//  SDBigMutableStarRatingCell.h
//  SDForms
//
//  Created by Radoslaw Szeja on 14.03.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDBigStarRatingView.h"

static NSString * const kBigMutableStarRatingCell = @"SDBigMutableStarRatingCell";

@interface SDBigMutableStarRatingCell : UITableViewCell

@property (nonatomic, strong) SDBigStarRatingView *starRatingView;
@property (nonatomic) BOOL interactionEnabled;

@end
