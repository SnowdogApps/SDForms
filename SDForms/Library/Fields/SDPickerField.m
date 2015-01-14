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

@property (nonatomic, strong) NSMutableArray *selectedIndexes;
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

- (id)initWithObject:(id)object relatedPropertyKey:(NSString *)key items:(NSArray *)items values:(NSArray *)values {
    self = [self initWithObjects:@[object] relatedPropertyKeys:@[key] items:@[items] values:@[values]];
    if (self) {
    }
    return self;
}

- (id)initWithObjects:(NSArray *)objects relatedPropertyKeys:(NSArray *)keys items:(NSArray *)items values:(NSArray *)values {
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

- (id)initWithObjects:(NSArray *)objects relatedPropertyKeys:(NSArray *)keys formattedValueKeys:(NSArray *)formattedKeys settableFormattedValueKeys:(NSArray *)settableFormattedKeys items:(NSArray *)items values:(NSArray *)values {
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
    [self validateValuesArray:self.values];
    _items = items;
    [self createSelectedIndexesArrayWithItems:items];
    [self fillSelectedValues];
}


- (void)setValues:(NSArray *)values
{
    [self validateValuesArray:values];
    _values = values;
    [self fillSelectedValues];
}

- (void)setMinimumSelectedIndexes:(NSArray *)minimumSelectedIndexes
{
    _minimumSelectedIndexes = minimumSelectedIndexes;
    if (self.items.count > 0) {
        [self createSelectedIndexesArrayWithItems:self.items];
        [self fillSelectedValues];
    }
}

- (void)setValue:(NSArray *)value
{
    [self setValue:value withCellRefresh:YES];
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

            [relatedObject setValue:val forKey:relatedKey];
        }
        i++;
    }
    
    [self updateFormattedValuesInRelatedObject];
}

- (void)updateFormattedValuesInRelatedObject {
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

- (void)setRelatedObjects:(NSArray *)relatedObjects
{
    [self validateValuesArray:self.values];
    _relatedObjects = relatedObjects;
    [self setValueBasedOnRelatedObjectProperty];
}

- (void)setRelatedPropertyKeys:(NSArray *)relatedPropertyKeys
{
    [self validateValuesArray:self.values];
    _relatedPropertyKeys = relatedPropertyKeys;
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
        
        int i = 0;
        for (id obj in values) {
            NSAssert([obj isKindOfClass:[NSArray class]], @"All objects of values array should be of (NSArray *) type");
            
            NSArray *items = [self.items objectAtIndex:i];
            NSAssert(((NSArray*)obj).count == items.count, @"All objects in values should have the same number of elements as corresponding objects in items array");
            i++;
        }
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

- (void)createSelectedIndexesArrayWithItems:(NSArray *)items
{
    NSMutableArray *selected = [NSMutableArray array];
    for (int i = 0; i < items.count; i++) {
        NSNumber *minIdx = [self.minimumSelectedIndexes objectAtIndex:i];
        
        if (minIdx != nil) {
            [selected addObject:minIdx];
        } else {
            [selected addObject:@0];
        }
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

- (void)setValueBasedOnRelatedObjectProperty
{
    if (self.relatedObjects && self.relatedPropertyKeys ) {
        for (int i = 0; i < self.relatedObjects.count; i++) {
            id val = [[self.relatedObjects objectAtIndex:i] valueForKey:[self.relatedPropertyKeys objectAtIndex:i]];
            NSArray *values = [self.values objectAtIndex:i];
            __block NSUInteger valueIndex = NSNotFound;
            [values enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if ([obj isEqual:val]) {
                    valueIndex = idx;
                    *stop = YES;
                }
            }];
            
            if (valueIndex == NSNotFound) {
                valueIndex = 0;
            }
            
            [self.selectedIndexes replaceObjectAtIndex:i withObject:@(valueIndex)];
            
        }
        
        self.isInitialValueSet = NO;
        [self fillSelectedValues];
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
        NSInteger minRow = [[self.minimumSelectedIndexes objectAtIndex:component] integerValue];
        if (row < minRow) {
            [pickerView selectRow:minRow inComponent:component animated:YES];
            [self createSelectedIndexesArrayWithItems:self.items];
            [self fillSelectedValues];
        } else {
            [self.selectedIndexes replaceObjectAtIndex:component withObject:@(row)];
            [self fillSelectedValues];
            
            if (self.pickerFieldDelegate && [self.pickerFieldDelegate respondsToSelector:@selector(pickerField:didSelectRow:inComponent:)]) {
                [self.pickerFieldDelegate pickerField:self didSelectRow:row inComponent:component];
            }
        }
    }
    
    [self updateFormattedValuesInRelatedObject];
    [self refreshFieldCell];
}


@dynamic value;


@end
