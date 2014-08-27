//
//  SDQuantityTypeCell.h
//  SDForms
//
//  Created by Rafal Kwiatkowski on 20.05.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDFormCell.h"
#import "SDSliderField.h"

static NSString * const kSliderCell = @"SDSliderCell";

@class SDSliderCell;

@protocol SDSliderCellDelegate <NSObject>

- (void) sliderCell:(SDSliderCell*)cell sliderValueHasChanged:(float)value;

@end

@interface SDSliderCell : SDFormCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (nonatomic, weak) SDSliderField *field;

@end
