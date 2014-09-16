//
//  SDTextViewField.m
//  SDForms
//
//  Created by Radoslaw Szeja on 15.09.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import "SDTextViewField.h"

@implementation SDTextViewField

- (id)init
{
    self = [super init];
    if (self) {
        self.editable = YES;
        self.selectable = YES;
    }
    return self;
}

- (void)registerCellsInTableView:(UITableView *)tableView
{
    [tableView registerNib:[UINib nibWithNibName:kTextViewCell bundle:self.defaultBundle] forCellReuseIdentifier:kTextViewCell];
    self.reuseIdentifiers = @[kTextViewCell];
}

- (SDFormCell *)cellForTableView:(UITableView *)tableView atIndex:(NSUInteger)index
{
    SDTextViewCell *cell = (SDTextViewCell *)[super cellForTableView:tableView atIndex:index];
    id value = [self.relatedObject valueForKeyPath:self.relatedPropertyKey];
    
    if (cell != nil && value != nil) {
        NSString *valueString = [NSString stringWithFormat:@"%@", value];
        
        if (valueString.length > 0) {
            cell.textView.editable = YES;
            cell.textView.selectable = YES;
            
            if (self.textFont != nil && self.textColor != nil) {
                NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:valueString attributes:@{NSFontAttributeName: self.textFont, NSForegroundColorAttributeName: self.textColor}];
                cell.textView.attributedText = attrString;
            } else if (self.textColor != nil) {
                NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:valueString attributes:@{NSForegroundColorAttributeName: self.textColor}];
                cell.textView.attributedText = attrString;
            } else if (self.textFont != nil) {
                NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:valueString attributes:@{NSFontAttributeName: self.textFont}];
                cell.textView.attributedText = attrString;
            } else {
                cell.textView.text = valueString;
            }
            
            cell.textView.editable = self.editable;
            cell.textView.selectable = self.selectable;
        }
    }
    
    return cell;
}

@end
