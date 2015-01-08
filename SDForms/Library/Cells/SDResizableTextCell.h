//
//  SDResizableTextCell.h
//  SDForms
//
//  Created by Rafal Kwiatkowski on 26.06.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const kResizableTextCell = @"SDResizableTextCell";

@interface SDResizableTextCell : UITableViewCell

@property (nonatomic, strong) NSString *text;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

+ (CGFloat) heightForText:(NSString*)text andCellWidth:(CGFloat)width;

@end
