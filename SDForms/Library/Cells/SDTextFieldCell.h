//
//  SDTextFieldCell.h
//  SDForms
//
//  Created by Rafal Kwiatkowski on 18.08.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDFormCell.h"
#import "SDTextField.h"

static NSString * const kTextFieldCell = @"SDTextFieldCell";

@interface SDTextFieldCell : SDFormCell <SDTextFieldDelegate>

@property (weak, nonatomic) IBOutlet SDTextField *textField;

@end
