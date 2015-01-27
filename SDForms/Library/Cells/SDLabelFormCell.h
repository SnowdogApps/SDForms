//
//  SDPollLabelCell.h
//  SDForms
//
//  Created by Radoslaw Szeja on 10.01.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDFormCell.h"

static NSString * const kLabelCell = @"SDLabelFormCell";

@interface SDLabelFormCell : SDFormCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@end
