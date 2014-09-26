//
//  SDMultilineTextFormField.m
//  SDForms
//
//  Created by Rafal Kwiatkowski on 26.08.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import "SDMultilineTextField.h"
#import "SDTextViewCell.h"
#import "NSMutableDictionary+SDExtensions.h"

#define SIDE_MARGIN    8.0
#define PADDING        5.0
#define INSET          16.0

@implementation SDMultilineTextField

- (id)init
{
    self = [super init];
    if (self) {
        self.textViewHeight = 0.0;
        self.editable = YES;
        self.selectable = YES;
        self.automaticHeight = NO;
    }
    return self;
}

- (void)registerCellsInTableView:(UITableView *)tableView
{
    [tableView registerNib:[UINib nibWithNibName:kTextViewCell bundle:self.defaultBundle] forCellReuseIdentifier:kTextViewCell];
    self.reuseIdentifiers = @[kTextViewCell];
    
    if (self.automaticHeight && !self.editable) {
        CGFloat height = [SDMultilineTextField heightForText:self.value font:self.textFont tableViewWidth:tableView.bounds.size.width];
        self.cellHeights = @[@(height)];
    } else if (self.textViewHeight > 0.0) {
        self.cellHeights = @[@(self.textViewHeight)];
    } else {
        self.cellHeights = @[@88.0];
    }
}

+ (CGFloat)heightForText:(NSString *)text font:(UIFont *)font tableViewWidth:(CGFloat)maxWidth;
{
    NSAttributedString *desc = [[NSAttributedString alloc] initWithString:(text ? text : @"") attributes:@{NSFontAttributeName: font}];
    NSStringDrawingOptions options = (NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin);
    
    CGFloat padding = 5.0;
    CGRect textSize = [desc boundingRectWithSize:CGSizeMake(maxWidth - 2.0 * padding - 2.0 * SIDE_MARGIN, CGFLOAT_MAX) options:options context:nil];
    
    CGFloat adj = ceilf(font.ascender - font.capHeight);
    CGFloat insets = 16.0;

    CGFloat height = textSize.size.height = ceil(textSize.size.height + adj + insets);
    
    return height;
}

- (SDFormCell *)cellForTableView:(UITableView *)tableView atIndex:(NSUInteger)index
{
    SDTextViewCell *cell = (SDTextViewCell *)[super cellForTableView:tableView atIndex:index];
    id value = self.value;
    
    if (cell != nil && value != nil) {
        NSString *valueString = [NSString stringWithFormat:@"%@", value];
        
        if (valueString.length > 0) {
            cell.textView.editable = YES;
            cell.textView.selectable = YES;

            NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:valueString attributes:@{NSFontAttributeName: self.textFont, NSForegroundColorAttributeName: self.textColor}];
            cell.textView.attributedText = attrString;
            cell.textView.editable = self.editable;
            cell.textView.selectable = self.selectable;
            cell.textView.userInteractionEnabled = (self.editable || self.selectable);
        }
    }
    
    return cell;
}

- (UIFont *)textFont
{
    if (!_textFont) {
        _textFont = [UIFont systemFontOfSize:14.0];
    }
    return _textFont;
}

- (UIColor *)textColor
{
    if (!_textColor) {
        _textColor = [UIColor darkTextColor];
    }
    return _textColor;
}

@end
