//
//  SDPollOtherDataCell.h
//  SDForms
//
//  Created by Radoslaw Szeja on 10.01.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDTextField.h"
#import "SDTextFieldCell.h"

static NSString * const kTextFieldWithLabelCell = @"SDTextFieldWithLabelCell";

@interface SDTextFieldWithLabelCell : SDTextFieldCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet SDTextField *textField;

@end
