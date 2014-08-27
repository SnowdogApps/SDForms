//
//  SDDataWithUnitCell.h
//  SDForms
//
//  Created by Rafal Kwiatkowski on 22.01.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDTextField.h"

static NSString * const kDataWithUnitCell = @"SDDataWithUnitCell";

@interface SDDataWithUnitCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet SDTextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;

@end
