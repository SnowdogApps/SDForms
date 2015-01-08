//
//  SDRecipeCell.h
//  SDForms
//
//  Created by Rafal Kwiatkowski on 03.03.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const kDescriptionCell = @"SDDescriptionCell";

@interface SDDescriptionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

+ (CGFloat) heightForText:(NSString*)text andCellWidth:(CGFloat)width;

@end
