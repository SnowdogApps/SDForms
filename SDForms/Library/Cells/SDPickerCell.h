//
//  SDPickerCell.h
//  SDForms
//
//  Created by Radoslaw Szeja on 13.01.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDFormCell.h"

static NSString * const kPickerCell = @"SDPickerCell";

@interface SDPickerCell : SDFormCell

@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (nonatomic, strong) NSArray *items;

@end
