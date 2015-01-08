//
//  SDPickerField.h
//  SDForms
//
//  Created by Rafal Kwiatkowski on 22.08.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import "SDFormField.h"

typedef enum {SDPickerFieldPickerTypeInRow, SDPickerFieldPickerTypeInView} SDPickerFieldPickerType;

@class SDPickerField;

@protocol SDPickerFieldCustomizationDelegate <SDFormFieldCustomizationDelegate>

- (NSString *)formattedValueForField:(SDPickerField *)field inComponent:(NSInteger)component;

@end

@protocol SDPickerFieldProtocol <NSObject>

- (void)pickerField:(SDPickerField *)field didSelectRow:(NSInteger)row inComponent:(NSInteger)component;

@end

@interface SDPickerField : SDFormField <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic) SDPickerFieldPickerType pickerType;

@property (nonatomic, strong) NSArray *items;   ///< Array of arrays of items. For each component contains array of its items. Items should be of NSString type
@property (nonatomic, strong) NSArray *values; ///< Array of arrays of values. For each component contains array of its values. Values can be of any object type
@property (nonatomic, strong) NSArray *value; ///< Array of selected values in all components
@property (nonatomic, strong) NSArray *formattedValue;
@property (nonatomic, strong) NSArray *relatedObjects;
@property (nonatomic, strong) NSArray *relatedPropertyKeys;
@property (nonatomic, strong) NSArray *settableFormattedValueKeys;
@property (nonatomic, copy) NSString *formattedValueSeparator;
@property (nonatomic, strong) NSArray *minimumSelectedIndexes; ///< Array of NSNumbers for each component

@property (nonatomic, weak) id<SDPickerFieldCustomizationDelegate> formatDelegate;
@property (nonatomic, weak) id<SDPickerFieldProtocol> pickerFieldDelegate;

- (NSInteger)numberOfComponents:(NSInteger)component;
- (NSArray *)itemsInComponent:(NSInteger)component;
- (NSUInteger)indexOfSelectedItemInComponent:(NSInteger)component;
- (void)selectItem:(NSUInteger)index inComponent:(NSInteger)component;
- (NSString *)itemAtIndex:(NSUInteger)index inComponent:(NSInteger)component;

@end
