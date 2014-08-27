//
//  SDRecipeCell.m
//  SDForms
//
//  Created by Rafal Kwiatkowski on 03.03.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import "SDDescriptionCell.h"

@implementation SDDescriptionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat) heightForText:(NSString*)text andCellWidth:(CGFloat)width
{
    if(!text)
        return 44.0;
    
    NSAttributedString *attributedDetails = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15.0]}];
    CGRect textSize = [attributedDetails boundingRectWithSize:CGSizeMake(width - (2*16.0), CGFLOAT_MAX) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) context:nil];
    if(textSize.size.height > 18.0) {
        CGFloat add = textSize.size.height - 18.0;
        return 44 + add;
    }
    else {
        return 44;
    }
}

@end
