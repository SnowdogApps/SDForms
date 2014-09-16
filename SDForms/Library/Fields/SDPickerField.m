//
//  SDPickerField.m
//  SDForms
//
//  Created by Rafal Kwiatkowski on 22.08.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import "SDPickerField.h"
#import "SDLabelCell.h"
#import "SDPickerCell.h"

@interface SDPickerField ()

@property (nonatomic, strong) NSMutableArray *selectedIndexes;

@end


@implementation SDPickerField

- (id)init
{
    self = [super init];
    if (self) {
        self.hasPicker = YES;
        self.pickerType = SDPickerFieldPickerTypeInRow;
    }
    return self;
}


#pragma mar - Field management methods


- (void)registerCellsInTableView:(UITableView *)tableView
{
    if (self.pickerType == SDPickerFieldPickerTypeInRow) {
        [tableView registerNib:[UINib nibWithNibName:kLabelCell bundle:self.defaultBundle] forCellReuseIdentifier:kLabelCell];
        [tableView registerNib:[UINib nibWithNibName:kPickerCell bundle:self.defaultBundle] forCellReuseIdentifier:kPickerCell];
        self.reuseIdentifiers = @[kLabelCell, kPickerCell];
        self.cellHeights = @[@44.0, @162.0];
    } else {
        [tableView registerNib:[UINib nibWithNibName:kLabelCell bundle:self.defaultBundle] forCellReuseIdentifier:kLabelCell];
        self.reuseIdentifiers = @[kLabelCell];
        self.cellHeights = @[@44.0];
    }
}


- (SDFormCell *)cellForTableView:(UITableView *)tableView atIndex:(NSUInteger)index
{
    SDFormCell *cell = [super cellForTableView:tableView atIndex:index];
    
    if ([cell isKindOfClass:[SDLabelCell class]]) {
        SDLabelCell *labelCell = (SDLabelCell *)cell;
        labelCell.titleLabel.text = self.title;
        labelCell.valueLabel.text = self.formattedValue;
    } else if ([cell isKindOfClass:[SDPickerCell class]]) {
        SDPickerCell *pickerCell = (SDPickerCell *)cell;
        pickerCell.picker.delegate = self;
        pickerCell.picker.dataSource = self;
        
        for (NSInteger i = 0; i < pickerCell.picker.numberOfComponents; i++) {
            [pickerCell.picker selectRow:[self indexOfSelectedItemInComponent:i] inComponent:i animated:NO];
        }
    }
    
    return cell;
}


#pragma mark - Getters, Setters and Validation


- (NSString *)formattedValue
{
    if (self.formatDelegate && [self.formatDelegate respondsToSelector:@selector(formattedValueForField:)]) {
        return [self.formatDelegate formattedValueForField:self];
    } else {
        NSString *title = @"";
        NSInteger component = 0;
        NSUInteger index = [self indexOfSelectedItemInComponent:component];
        if (component < self.items.count) {
            NSArray *array = [self.items objectAtIndex:component];
            
            if (index < array.count) {
                title = [array objectAtIndex:index];
            }
        }
        return title;
    }
}

- (void)setItems:(NSArray *)items
{
    [self validateItemsArray:items];
    
    if (self.values) {
        [self validateValuesArray:self.values];
    }
    
    _items = items;
    
    [self createSelectedIndexesArrayWithItems:items];
    [self fillSelectedValues];
}

- (void)createSelectedIndexesArrayWithItems:(NSArray *)items
{
    NSMutableArray *selected = [NSMutableArray array];
    for (int i = 0; i < items.count; i++) {
        [selected addObject:@0];
    }
    self.selectedIndexes = [selected mutableCopy];
}

- (void)validateItemsArray:(NSArray *)items
{
    for (id obj in items) {
        NSAssert([obj isKindOfClass:[NSArray class]], @"All objects of items array should be of (NSArray *) type");
        for (id item in (NSArray*)obj) {
            NSAssert([item isKindOfClass:[NSString class]], @"All items should be of (NSString *) type");
        }
    }
}


- (void)setValues:(NSArray *)values
{
    [self validateValuesArray:values];
    _values = values;
    [self fillSelectedValues];
}


- (void)validateValuesArray:(NSArray *)values
{
    if (self.items) {
        NSAssert(values.count == self.items.count, @"values array should have the same number of objecta as items array");
    }
    
    int i = 0;
    for (id obj in values) {
        NSAssert([obj isKindOfClass:[NSArray class]], @"All objects of values array should be of (NSArray *) type");
        
        NSArray *items = [self.items objectAtIndex:i];
        NSAssert(((NSArray*)obj).count == items.count, @"All objects in values should have the same number of elements as corresponding objects in items array");
        i++;
    }
}


- (void)fillSelectedValues
{
    if (self.values) {
        NSMutableArray *selectedValues = [[NSMutableArray alloc] init];
        if (self.selectedIndexes) {
            for (int i = 0; i < self.selectedIndexes.count; i++) {
                NSNumber *index = [self.selectedIndexes objectAtIndex:i];
                NSArray *values = [self.values objectAtIndex:i];
                [selectedValues addObject:[values objectAtIndex:index.integerValue]];
            }
        } else {
            for (int i = 0; i < _values.count; i++) {
                NSArray *values = [self.values objectAtIndex:i];
                NSInteger index = 0;
                [selectedValues addObject:[values objectAtIndex:index]];
            }
        }
        self.value = selectedValues;
    }
}


- (void)setValue:(NSArray *)value
{
    [self setValue:value withCellRefresh:YES];
}

- (void)setValue:(id)value withCellRefresh:(BOOL)refresh
{
    _value = value;
    
    int i = 0;
    for (id val in _value) {
        
        if (i < self.relatedObjects.count && i < self.relatedPropertyKeys.count) {
            id relatedObject = [self.relatedObjects objectAtIndex:i];
            NSString *relatedKey = [self.relatedPropertyKeys objectAtIndex:i];
            [relatedObject setValue:val forKey:relatedKey];
        }
        i++;
    }
    
    if (refresh) {
        [self refreshFieldCell];
    }
}


#pragma mark - Managing items


- (NSInteger)numberOfComponents:(NSInteger)component
{
    return self.items.count;
}


- (NSArray *)itemsInComponent:(NSInteger)component
{
    if (component < self.items.count) {
        NSArray *array = [self.items objectAtIndex:component];
        return array;
    }
    return nil;
}


- (NSUInteger)indexOfSelectedItemInComponent:(NSInteger)component
{
    if (component < self.selectedIndexes.count) {
        NSNumber *selectedItem = [self.selectedIndexes objectAtIndex:component];
        return selectedItem.unsignedIntegerValue;
    }
    return 0;
}


- (void)selectItem:(NSUInteger)index inComponent:(NSInteger)component
{
    if (component < self.selectedIndexes.count) {
        [self.selectedIndexes replaceObjectAtIndex:component withObject:@(index)];
        [self fillSelectedValues];
        [self refreshFieldCell];
    }
}


- (NSString *)itemAtIndex:(NSUInteger)index inComponent:(NSInteger)component
{
    if (component < self.items.count) {
        NSArray *array = [self.items objectAtIndex:component];
        
        if (index < array.count) {
            NSString *item = [array objectAtIndex:index];
            return item;
        }
        return nil;
    }
    return nil;
}


#pragma mark - UIPickerView stuff

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return self.items.count;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component < self.items.count) {
        NSArray *array = [self.items objectAtIndex:component];
        return array.count;
    }
    return 0;
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component < self.items.count) {
        NSArray *array = [self.items objectAtIndex:component];
        
        if (row < array.count) {
            NSString *title = [array objectAtIndex:row];
            return title;
        }
        return @"";
    }
    return @"";
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component < self.selectedIndexes.count) {
        [self.selectedIndexes replaceObjectAtIndex:component withObject:@(row)];
        [self fillSelectedValues];
        
        if (self.pickerFieldDelegate && [self.pickerFieldDelegate respondsToSelector:@selector(pickerView:didSelectRow:inComponent:)]) {
            [self.pickerFieldDelegate pickerField:self didSelectRow:row inComponent:component];
        }
    }
    [self refreshFieldCell];
}


@synthesize value = _value;


@end
