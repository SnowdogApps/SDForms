//
//  SDSwitchCell.h
//  SDForms
//
//  Created by Radoslaw Szeja on 14.01.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDFormCell.h"

static NSString * const kSwitchCell = @"SDSwitchFormCell";

@interface SDSwitchFormCell : SDFormCell
@property (weak, nonatomic) IBOutlet UISwitch *switchControl;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end
