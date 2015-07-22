//
//  SDMultilineTextFormField.m
//  SDForms
//
//  Created by Rafal Kwiatkowski on 26.08.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import "SDMultilineTextField.h"
#import "SDTextViewFormCell.h"
#import "NSMutableDictionary+SDExtensions.h"

#define SIDE_MARGIN    8.0
#define PADDING        5.0
#define INSET          16.0

@interface SDMultilineTextField ()

@property (nonatomic, strong) NSArray *heights;

@end

@implementation SDMultilineTextField

- (id)init
{
    self = [super init];
    if (self) {
        self.textViewHeight = 0.0;
        self.editable = YES;
        self.selectable = YES;
        self.automaticHeight = NO;
        self.placeholderVisible = YES;
        self.dataDetectorTypes = UIDataDetectorTypeNone;
    }
    return self;
}

- (void)registerCellsInTableView:(UITableView *)tableView
{
    [super registerCellsInTableView:tableView];
    
    if (self.automaticHeight && !self.editable) {
        CGFloat maxWidth = tableView.frame.size.width;
        if (self.canBeDeleted) {
            maxWidth -= 40.0;   //approximate left content view's inset when delete button is visible
        }
        CGFloat height = [SDMultilineTextField heightForText:self.value font:self.textFont tableViewWidth:maxWidth];
        self.heights = @[@(height)];
    } else if (self.textViewHeight > 0.0) {
        self.heights = @[@(self.textViewHeight)];
    } else {
        self.heights = @[@88.0];
    }
}

- (NSArray *)reuseIdentifiers {
    return @[kTextViewCell];
}

- (NSArray *)cellHeights {
    return self.heights;
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
    SDTextViewFormCell *cell = (SDTextViewFormCell *)[super cellForTableView:tableView atIndex:index];

    cell.textView.dataDetectorTypes = self.dataDetectorTypes;
    cell.editable = self.editable;
    cell.selectable = self.selectable;
    cell.placeHolder = self.placeholder;
    cell.textColor = self.textColor;
    cell.textFont = self.textFont;
    cell.textView.backgroundColor = self.backgroundColor;
    cell.placeholderVisible = self.placeholderVisible;
    id value = self.value;
    
    if (value != nil) {
        NSString *valueString = [NSString stringWithFormat:@"%@", value];
        cell.text = valueString;
    } else {
        cell.text = nil;
    }
    
    cell.textView.userInteractionEnabled = (self.editable || self.selectable);
    
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

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    if (!self.placeholder) {
        self.placeholder = title;
    }
}

@end
