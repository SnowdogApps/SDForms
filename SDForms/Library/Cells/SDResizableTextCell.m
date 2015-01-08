//
//  SDResizableTextCell.m
//  SDForms
//
//  Created by Rafal Kwiatkowski on 26.06.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import "SDResizableTextCell.h"

static CGFloat const kBaseHeight = 44.0;
static CGFloat const kBaseFontSize = 17.0;
static CGFloat const kBaseLabelHeight= 21.0;
static CGFloat const kHorizontalMargin = 15.0;

@interface SDResizableTextCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstraint;

@end

@implementation SDResizableTextCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

+ (CGFloat) heightForText:(NSString*)text andCellWidth:(CGFloat)width
{
    if(!text)
        return kBaseHeight;
    
    NSAttributedString *attributedDetails = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:kBaseFontSize]}];
    CGRect textSize = [attributedDetails boundingRectWithSize:CGSizeMake(width - (2 * kHorizontalMargin), CGFLOAT_MAX) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) context:nil];
    if(textSize.size.height > kBaseLabelHeight) {
        CGFloat add = textSize.size.height - kBaseLabelHeight;
        return kBaseHeight + add;
    }
    else {
        return kBaseHeight;
    }
}

- (void)setText:(NSString *)text
{
    self.titleLabel.text = text;
}

- (NSString *)text
{
    return self.titleLabel.text;
}

@end
