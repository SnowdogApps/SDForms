//
//  SDChooseGoalsCell.h
//  SDForms
//
//  Created by Rafal Kwiatkowski on 21.01.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const kButtonCell = @"SDButtonCell";

@interface SDButtonCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *mainLabel;
@property (weak, nonatomic) IBOutlet UIImageView *doneImage;

@end
