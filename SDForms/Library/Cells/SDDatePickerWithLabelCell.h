//
//  SDPickerWithLabelCell.h
//  SDForms
//
//  Created by Radoslaw Szeja on 26.03.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import "SDDatePickerCell.h"


static NSString * const kDatePickerWithLabelCell = @"SDDatePickerWithLabelCell";

@interface SDDatePickerWithLabelCell : SDDatePickerCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end
