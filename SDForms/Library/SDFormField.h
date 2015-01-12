//
//  SDFormField.h
//  SDForms
//
//  Created by Rafal Kwiatkowski on 13.08.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class SDFormCell, SDFormField, SDForm;

typedef enum {SDFormFieldPresentingModePush, SDFormFieldPresentingModeModal} SDFormFieldPresentingMode;

typedef enum {SDFormFieldValueTypeText, SDFormFieldValueTypeDouble, SDFormFieldValueTypeInt} SDFormFieldValueType;

@protocol SDFormFieldCustomizationDelegate <NSObject>

- (NSString *)formattedValueForField:(SDFormField *)field;

@end

@protocol SDFormFieldDelegate <NSObject>

- (void)formFieldDidUpdateValue:(SDFormField *)field;
- (void)formField:(SDFormField *)formField pushesViewController:(UIViewController *)controller animated:(BOOL)animated;
- (void)formField:(SDFormField *)formField presentsViewController:(UIViewController *)controller animated:(BOOL)animated;

@end

typedef void(^on_value_changed_t)(id originalValue, id newValue, SDFormField *field);

@interface SDFormField : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) id value;
@property (nonatomic) SDFormFieldValueType valueType;
@property (nonatomic, strong) id formattedValue;
@property (nonatomic) BOOL hasPicker;
@property (nonatomic) BOOL enabled;
@property (nonatomic, strong) NSArray *reuseIdentifiers;
@property (nonatomic, strong) NSArray *cellHeights;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic) SDFormFieldPresentingMode presentingMode; ///<Tells the field how it should present its view controllers. By default it's set to SDFormFieldPresentingModePush
@property (nonatomic, strong) id relatedObject;
@property (nonatomic, strong) NSString *relatedPropertyKey;
@property (nonatomic, strong) NSString *formattedValueKey;
@property (nonatomic, strong) NSString *settabeFormattedValueKey;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *editedBackgroundColor;
@property (nonatomic) BOOL markWhenEdited;
@property (nonatomic) BOOL edited;
@property (nonatomic, strong) NSString *segueIdentifier;
@property (nonatomic, strong) void (^onTapBlock)();
@property (nonatomic, readonly) NSBundle *defaultBundle;

@property (nonatomic, strong) on_value_changed_t onValueChangedBlock;
@property (nonatomic) BOOL canBeDeleted;

@property (nonatomic, weak) id<SDFormFieldDelegate> delegate;
@property (nonatomic, weak) id<SDFormFieldCustomizationDelegate> formatDelegate;

- (id)initWithObject:(id)object relatedPropertyKey:(NSString *)key;
- (id)initWithObject:(id)object relatedPropertyKey:(NSString *)key formattedValueKey:(NSString *)formattedKey settableFormattedValueKey:(NSString *)settableFormattedKey;
- (void)registerCellsInTableView:(UITableView*)tableView;
- (SDFormCell *)cellForTableView:(UITableView*)tableView atIndex:(NSUInteger)index;
- (void)willDisplayCell:(SDFormCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)heightForCellInTableView:(UITableView *)tableView atIndex:(NSUInteger)index;
- (void)setValue:(id)value withCellRefresh:(BOOL)refresh;
- (void)refreshFieldCell;
- (void)form:(SDForm *)form didSelectFieldAtIndex:(NSInteger)index;
- (void)presentViewController:(UIViewController *)controller animated:(BOOL)animated;

@end
