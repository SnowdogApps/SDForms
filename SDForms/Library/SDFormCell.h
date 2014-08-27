//
//  SDFormBaseCell.h
//  SDForms
//
//  Created by Rafal Kwiatkowski on 14.08.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDFormField.h"

@protocol SDFormCellDelegate <NSObject>

- (void)formCell:(SDFormCell *)cell didActivateResponder:(UIView*)view;
- (void)formCell:(SDFormCell *)cell didDeactivateResponder:(UIView*)view;
- (UIView *)inputAccessoryViewForCell:(SDFormCell *)cell;

@end

@interface SDFormCell : UITableViewCell <UITextFieldDelegate>

@property (nonatomic, weak) SDFormField *field;
@property (nonatomic, strong) NSArray *responders;

@property (nonatomic, weak) id<SDFormCellDelegate> delegate;

@end
