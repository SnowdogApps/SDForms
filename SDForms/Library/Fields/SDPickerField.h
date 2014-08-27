//
//  SDPickerField.h
//  SDForms
//
//  Created by Rafal Kwiatkowski on 22.08.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import "SDFormField.h"

typedef enum {SDPickerFieldPickerTypeInRow, SDPickerFieldPickerTypeInView} SDPickerFieldPickerType;

@interface SDPickerField : SDFormField <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic) SDPickerFieldPickerType pickerType;

@property (nonatomic, strong) NSArray *items;   ///< Array of arrays of items. For each component contains array of its items. Items should be of NSString type

- (NSInteger)numberOfComponents:(NSInteger)component;
- (NSArray *)itemsInComponent:(NSInteger)component;
- (NSUInteger)indexOfSelectedItemInComponent:(NSInteger)component;
- (void)selectItem:(NSUInteger)index inComponent:(NSInteger)component;
- (NSString *)itemAtIndex:(NSUInteger)index inComponent:(NSInteger)component;

@end
