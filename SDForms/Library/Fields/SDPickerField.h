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
@property (nonatomic, readonly) NSArray *formattedValue; ///< Array of formatted values for all components
@property (nonatomic, strong) NSArray *relatedObjects;  ///< Array of field's related objects
@property (nonatomic, strong) NSArray *relatedPropertyKeys; ///< Array of key paths to related objects' properties related to the field
@property (nonatomic, strong) NSArray *formattedValueKeys;  ///< Array of key paths to related objects' properties that will be dispayed as field's formatted value
@property (nonatomic, strong) NSArray *settableFormattedValueKeys;  ///< Array of key paths to related objects' properties that will be set by the field with its formattedValue property value
@property (nonatomic, copy) NSString *formattedValueSeparator;      ///< Separator that will join formatted values for all components
@property (nonatomic, strong) NSArray *minimumSelectedIndexes; ///< Array of NSNumbers for each component

@property (nonatomic, weak) id<SDPickerFieldCustomizationDelegate> formatDelegate;  ///<Field's format delegate
@property (nonatomic, weak) id<SDPickerFieldProtocol> pickerFieldDelegate;          ///<Picker field's delegate

- (id)initWithObjects:(NSArray *)objects
  relatedPropertyKeys:(NSArray *)keys
                items:(NSArray *)items
               values:(NSArray *)values;

- (id)initWithObjects:(NSArray *)objects
  relatedPropertyKeys:(NSArray *)keys
   formattedValueKeys:(NSArray *)formattedKeys
settableFormattedValueKeys:(NSArray *)settableFormattedKeys
                items:(NSArray *)items
               values:(NSArray *)values;

- (NSInteger)numberOfComponents:(NSInteger)component;
- (NSArray *)itemsInComponent:(NSInteger)component;
- (NSUInteger)indexOfSelectedItemInComponent:(NSInteger)component;
- (void)selectItem:(NSUInteger)index inComponent:(NSInteger)component;
- (NSString *)itemAtIndex:(NSUInteger)index inComponent:(NSInteger)component;

@end
