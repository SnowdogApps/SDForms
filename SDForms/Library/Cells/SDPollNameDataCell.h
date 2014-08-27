//
//  SDPollNameDataCell.h
//  SDForms
//
//  Created by Radoslaw Szeja on 09.01.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDTextField.h"

static NSString * const kNameDataCell = @"SDPollNameDataCell";

@class SDPollNameDataCell;

@protocol SDPollNameDataCellDelegate <NSObject>

- (void) pollNameDataCellDidTapPhotoButton:(SDPollNameDataCell*)pollNameDataCell;

@end

@interface SDPollNameDataCell : UITableViewCell

@property (weak, nonatomic) id<SDPollNameDataCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet SDTextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet SDTextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIButton *photoButton;

- (IBAction)photoButtonTapped:(id)sender;

@end