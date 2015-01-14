//
//  SDDatePickerCell.h
//  SDForms
//
//  Created by Radoslaw Szeja on 13.01.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDFormCell.h"

static NSString * const kDatePickerCell = @"SDDatePickerFormCell";

@interface SDDatePickerFormCell : SDFormCell

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

- (IBAction)dateChanged:(id)sender;

@end
