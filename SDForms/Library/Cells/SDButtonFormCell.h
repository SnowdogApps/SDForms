//
//  SDChooseGoalsCell.h
//  SDForms
//
//  Created by Rafal Kwiatkowski on 21.01.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDFormCell.h"

static NSString * const kButtonCell = @"SDButtonFormCell";

@interface SDButtonFormCell : SDFormCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
