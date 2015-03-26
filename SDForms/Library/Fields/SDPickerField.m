//
//  SDPickerField.m
//  SDForms
//
//  Created by Rafal Kwiatkowski on 22.08.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import "SDPickerField.h"
#import "SDLabelFormCell.h"
#import "SDPickerFormCell.h"

@interface SDPickerField ()

@property (nonatomic, strong) SDPickerFormCell *pickerCell;

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

- (id)initWithObjects:(NSArray *)objects
  relatedPropertyKeys:(NSArray *)keys
                items:(NSArray *)items
               values:(NSArray *)values {
    self = [self init];
    if (self) {
        self.items = items;
        self.values = values;
        self.relatedObjects = objects;
        self.relatedPropertyKeys = keys;
        [self setValueBasedOnRelatedObjectProperty];
    }
    return self;
}

- (id)initWithObjects:(NSArray *)objects
  relatedPropertyKeys:(NSArray *)keys
   formattedValueKeys:(NSArray *)formattedKeys
settableFormattedValueKeys:(NSArray *)settableFormattedKeys
                items:(NSArray *)items values:(NSArray *)values {
    self = [self init];
    if (self) {
        self.items = items;
        self.values = values;
        self.relatedObjects = objects;
        self.relatedPropertyKeys = keys;
        self.formattedValueKeys = formattedKeys;
        self.settableFormattedValueKeys = settableFormattedKeys;
        [self setValueBasedOnRelatedObjectProperty];
    }
    return self;
}

#pragma mar - Field management methods


- (NSArray *)reuseIdentifiers {
    if (self.pickerType == SDPickerFieldPickerTypeInRow) {
        return @[kLabelCell, kPickerCell];
    } else {
        return @[kLabelCell];
    }
}

- (NSArray *)cellHeights {
    if (self.pickerType == SDPickerFieldPickerTypeInRow) {
        return @[@44.0, @162.0];
    } else {
        return @[@44.0];
    }
}

- (SDFormCell *)cellForTableView:(UITableView *)tableView atIndex:(NSUInteger)index
{
    SDFormCell *cell = [super cellForTableView:tableView atIndex:index];
    
    if ([cell isKindOfClass:[SDLabelFormCell class]]) {
        SDLabelFormCell *labelCell = (SDLabelFormCell *)cell;
        labelCell.titleLabel.text = self.title;
        
        if (self.formattedValueSeparator.length > 0) {
            labelCell.valueLabel.text = [self.formattedValue componentsJoinedByString:self.formattedValueSeparator];
        } else {
            labelCell.valueLabel.text = self.formattedValue.firstObject;
        }
    } else if ([cell isKindOfClass:[SDPickerFormCell class]]) {
        SDPickerFormCell *pickerCell = (SDPickerFormCell *)cell;
        pickerCell.picker.delegate = self;
        pickerCell.picker.dataSource = self;
        
        for (NSInteger i = 0; i < pickerCell.picker.numberOfComponents; i++) {
            NSInteger idx = [self indexOfSelectedItemInComponent:i];
            NSInteger minimumIdx = [[self.minimumSelectedIndexes objectAtIndex:i] integerValue];
            idx = (idx < minimumIdx) ? minimumIdx : idx;
            [pickerCell.picker selectRow:idx inComponent:i animated:NO];
        }
        
        self.pickerCell = pickerCell;
    }
    
    return cell;
}

- (void)dealloc
{
    if (self.pickerCell.picker.delegate == self && self.pickerCell.picker.dataSource == self) {
        self.pickerCell.picker.delegate = nil;
        self.pickerCell.picker.dataSource = nil;
    }
    _pickerCell = nil;
}


#pragma mark - Getters, Setters and Validation


- (NSArray *)formattedValue
{
    NSMutableArray *formattedValues = [NSMutableArray array];
    
    if (self.formatDelegate && [self.formatDelegate respondsToSelector:@selector(formattedValueForField:inComponent:)]) {
        
        for (int i = 0; i < self.value.count; i++) {
            NSString *formattedValue = [self.formatDelegate formattedValueForField:self inComponent:i];
            if (formattedValue) {
                [formattedValues addObject:formattedValue];
            }
        }

    } else if (self.relatedObject && self.formattedValueKey) {
        for (int i = 0; i < self.relatedObjects.count; i++) {
            id relatedObject = [self.relatedObjects objectAtIndex:i];
            NSString *key = [self.formattedValueKeys objectAtIndex:i];
            NSString *formattedValue = [relatedObject valueForKey:key];
            
            if (formattedValue) {
                [formattedValues addObject:formattedValue];
            }
        }
    } else {
        for (int i = 0; i < self.items.count; i++) {
            NSUInteger index = [self indexOfSelectedItemInComponent:i];
            NSArray *array = [self.items objectAtIndex:i];
            NSString *formattedValue = [array objectAtIndex:index];
            if (formattedValue) {
                [formattedValues addObject:formattedValue];
            }
        }
    }
    
    return formattedValues;
}

- (void)setItems:(NSArray *)items
{
    [self validateItemsArray:items];
    _items = items;
    [self validateValuesArray:self.values];
    [self setValueBasedOnRelatedObjectProperty];
}


- (void)setValues:(NSArray *)values
{
    [self validateValuesArray:values];
    _values = values;
    [self setValueBasedOnRelatedObjectProperty];
}

- (void)setValue:(NSArray *)value
{
    NSAssert(value.count == self.values.count, @"value must be equal to number of components");
    NSMutableArray *selectedValues = [NSMutableArray array];
    
    for (NSInteger i = 0; i < self.values.count; i++) {
        id val = [value objectAtIndex:i];
        NSArray *itemValues = [self.values objectAtIndex:i];
        NSInteger index = [self indexOfValue:val inArray:itemValues];
        if (index == NSNotFound || index < [self minimumIndexInComponent:i]) {
            index = [self minimumIndexInComponent:i];
        }
        
        [selectedValues addObject:[itemValues objectAtIndex:index]];
    }
    
    [self setValue:selectedValues withCellRefresh:YES];
}

- (void)setRelatedObjects:(NSArray *)relatedObjects
{
    _relatedObjects = relatedObjects;
    [self validateValuesArray:self.values];
    [self setValueBasedOnRelatedObjectProperty];
}

- (void)setRelatedPropertyKeys:(NSArray *)relatedPropertyKeys
{
    _relatedPropertyKeys = relatedPropertyKeys;
    [self validateValuesArray:self.values];
    [self setValueBasedOnRelatedObjectProperty];
}


- (id)relatedObject
{
    if (self.relatedObjects.count > 0) {
        return [self.relatedObjects objectAtIndex:0];
    }
    return nil;
}

- (void)setRelatedObject:(id)relatedObject
{
    if (relatedObject) {
        self.relatedObjects = @[relatedObject];
    } else {
        self.relatedObjects = nil;
    }
}

- (NSString *)relatedPropertyKey
{
    if (self.relatedPropertyKeys.count > 0) {
        return [self.relatedPropertyKeys objectAtIndex:0];
    }
    return nil;
}

- (void)setRelatedPropertyKey:(NSString *)relatedPropertyKey
{
    if (relatedPropertyKey) {
        self.relatedPropertyKeys = @[relatedPropertyKey];
    } else {
        self.relatedPropertyKeys = nil;
    }
}

- (void)setFormattedValueKey:(NSString *)formattedValueKey {
    if (formattedValueKey) {
        self.formattedValueKeys = @[formattedValueKey];
    } else {
        self.formattedValueKeys = nil;
    }
}

- (void)setFormattedValueKeys:(NSArray *)formattedValueKeys {
    _formattedValueKeys = formattedValueKeys;
    [self validateValuesArray:self.values];
}

- (void)setSettabeFormattedValueKey:(NSString *)settabeFormattedValueKey
{
    if (settabeFormattedValueKey) {
        self.settableFormattedValueKeys = @[settabeFormattedValueKey];
    } else {
        self.settableFormattedValueKeys = nil;
    }
}

- (void)setSettableFormattedValueKeys:(NSArray *)settableFormattedValueKeys
{
    _settableFormattedValueKeys = settableFormattedValueKeys;
    [self validateValuesArray:self.values];
    [self setRelatedObjectsProperties];
}

- (void)validateValuesArray:(NSArray *)values
{
    if (values) {
        if (self.items) {
            NSAssert(values.count == self.items.count, @"values array should have the same number of objecta as items array");
        }
        
        if (self.relatedObjects) {
            NSAssert(values.count == self.relatedObjects.count, @"values array should have the same number of objecta as relatedObjects array");
        }
        
        if (self.relatedPropertyKeys) {
            NSAssert(values.count == self.relatedPropertyKeys.count, @"values array should have the same number of objecta as relatedPropertyKeys array");
        }
        
        if (self.formattedValueKeys) {
            NSAssert(values.count == self.formattedValueKeys.count, @"values array should have the same number of objecta as relatedPropertyKeys array");
        }
        
        if (self.settableFormattedValueKeys) {
            NSAssert(values.count == self.settableFormattedValueKeys.count, @"values array should have the same number of objecta as relatedPropertyKeys array");
        }
        
        int i = 0;
        for (id obj in values) {
            NSAssert([obj isKindOfClass:[NSArray class]], @"All objects of values array should be of (NSArray *) type");
            
            NSArray *items = [self.items objectAtIndex:i];
            NSAssert(((NSArray*)obj).count == items.count, @"All objects in values should have the same number of elements as corresponding objects in items array");
            i++;
        }
    }
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

#pragma mark - Progressing fields value with related object and vice versa

- (void)setValueBasedOnRelatedObjectProperty
{
    if (self.items && self.values) {
        
        self.isInitialValueSet = NO;
        NSMutableArray *selectedValues = [[NSMutableArray alloc] init];
        
        if (self.relatedObjects && self.relatedPropertyKeys) {
            
            for (int i = 0; i < self.values.count; i++) {
                
                NSArray *values = [self.values objectAtIndex:i];
                id relatedObject = [self.relatedObjects objectAtIndex:i];
                NSString *relatedKey = [self.relatedPropertyKeys objectAtIndex:i];
                id val = [relatedObject valueForKeyPath:relatedKey];
                
                NSInteger index = [self indexOfValue:val inArray:values];
                if (index == NSNotFound || index < [self minimumIndexInComponent:i]) {
                    index = [self minimumIndexInComponent:i];
                }
                
                [selectedValues addObject:[values objectAtIndex:index]];
            }
            
        } else {
            for (int i = 0; i < self.values.count; i++) {
                [selectedValues addObject:@[@0]];
            }
        }
        
        self.value = selectedValues;
    }
}

- (void)setRelatedObjectProperty {
    [self setRelatedObjectsProperties];
}

- (void)setRelatedObjectsProperties
{
    int i = 0;
    for (id val in self.value) {
        if (i < self.relatedObjects.count && i < self.relatedPropertyKeys.count) {
            id relatedObject = [self.relatedObjects objectAtIndex:i];
            NSString *relatedKey = [self.relatedPropertyKeys objectAtIndex:i];
            
            
            if (![[relatedObject valueForKey:relatedKey] isEqual:val]) {
                [relatedObject setValue:val forKey:relatedKey];
            }
        }
        i++;
    }
    
    int j = 0;
    for (id formattedValue in self.formattedValue) {
        if (j < self.relatedObjects.count && j < self.settableFormattedValueKeys.count) {
            id relatedObject = [self.relatedObjects objectAtIndex:j];
            NSString *relatedKey = [self.settableFormattedValueKeys objectAtIndex:j];
            [relatedObject setValue:formattedValue forKey:relatedKey];
        }
        j++;
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
        
        NSArray *itemValues = [self.values objectAtIndex:component];
        self.value = [itemValues objectAtIndex:index];
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

- (NSInteger)minimumIndexInComponent:(NSInteger)component {
    if (self.minimumSelectedIndexes && component < self.minimumSelectedIndexes.count) {
        return [[self.minimumSelectedIndexes objectAtIndex:component] integerValue];
    }
    return 0;
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


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    NSInteger minRow = [[self.minimumSelectedIndexes objectAtIndex:component] integerValue];
    NSInteger realRow = row < minRow ? minRow : row;
    
    if (row < minRow) {
        [pickerView selectRow:minRow inComponent:component animated:YES];
    }
    
    NSArray *itemValues = [self.values objectAtIndex:component];
    self.value = [itemValues objectAtIndex:realRow];
    
    if (self.pickerFieldDelegate && [self.pickerFieldDelegate respondsToSelector:@selector(pickerField:didSelectRow:inComponent:)]) {
        [self.pickerFieldDelegate pickerField:self didSelectRow:realRow inComponent:component];
    }
}


- (NSArray *)selectedIndexes {
    NSMutableArray *selectedIndexes = [NSMutableArray array];
    NSInteger i = 0;
    
    for (NSArray *itemValues in self.values) {
        NSInteger index = [self minimumIndexInComponent:i];
        
        if (self.value) {
            id value = [self.value objectAtIndex:i];
            index = [self indexOfValue:value inArray:itemValues];
            if (index == NSNotFound || index < [self minimumIndexInComponent:i]) {
                index = [self minimumIndexInComponent:i];
            }
        }
        
        [selectedIndexes addObject:@(index)];
        i++;
    }
    
    return selectedIndexes;
}


- (NSInteger)indexOfValue:(id)value inArray:(NSArray *)array {
    __block NSInteger index = NSNotFound;
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isEqual:value]) {
            index = idx;
            *stop = YES;
        }
    }];
    return index;
}

@dynamic value;


@end
