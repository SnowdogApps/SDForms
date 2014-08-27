//
//  SDFormField.m
//  SDForms
//
//  Created by Rafal Kwiatkowski on 13.08.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import "SDFormField.h"
#import "SDFormCell.h"

@implementation SDFormField

- (id)initWithObject:(id)object relatedPropertyKey:(NSString *)key
{
    self = [self init];
    if (self) {
        self.relatedObject = object;
        self.relatedPropertyKey = key;
        
        _value = [self.relatedObject valueForKey:self.relatedPropertyKey];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        _hasPicker = NO;
    }
    return self;
}

- (void)registerCellsInTableView:(UITableView *)tableView
{
    
}

- (SDFormCell*)cellForTableView:(UITableView *)tableView atIndex:(NSUInteger)index
{
    if (index < self.reuseIdentifiers.count) {
        NSString *reuseIdentifier = [self.reuseIdentifiers objectAtIndex:index];
        SDFormCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.field = self;
        return cell;
    }
    return nil;
}

- (CGFloat)heightForCellInTableView:(UITableView *)tableView atIndex:(NSUInteger)index
{
    if (index < self.cellHeights.count) {
        NSNumber *height = [self.cellHeights objectAtIndex:index];
        return height.floatValue;
    }
    return 44.0;
}

- (void)setValue:(id)value
{
    _value = value;
    
    if (self.relatedObject && self.relatedPropertyKey) {
        [self.relatedObject setValue:value forKey:self.relatedPropertyKey];
    }
    
    [self refreshFieldCell];
}

- (NSString *)formattedValue
{
    if (self.formatDelegate && [self.formatDelegate respondsToSelector:@selector(formattedValueForField:)]) {
        NSString *title = [self.formatDelegate formattedValueForField:self];
        return title;
    }
    
    if (self.value) {
        return [NSString stringWithFormat:@"%@", self.value];
    } else {
        return @"";
    }
}

- (void)refreshFieldCell
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(formFieldDidUpdateValue:)]) {
        [self.delegate formFieldDidUpdateValue:self];
    }
}

- (void)form:(SDForm *)form didSelectFieldAtIndex:(NSInteger)index
{
    
}

- (void)presentViewController:(UIViewController *)controller animated:(BOOL)animated
{
    if (self.presentingMode == SDFormFieldPresentingModePush && self.delegate) {
        if ([self.delegate respondsToSelector:@selector(formField:pushesViewController:animated:)]) {
            [self.delegate formField:self pushesViewController:controller animated:animated];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(formField:presentsViewController:animated:)]) {
            [self.delegate formField:self presentsViewController:[[UINavigationController alloc] initWithRootViewController:controller] animated:YES];
        }
    }
}

@end
