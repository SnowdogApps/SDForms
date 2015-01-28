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

- (UIViewController *)viewControllerForField:(SDFormField *)field;
- (void)formFieldDidUpdateValue:(SDFormField *)field;
- (void)formField:(SDFormField *)formField pushesViewController:(UIViewController *)controller animated:(BOOL)animated;
- (void)formField:(SDFormField *)formField presentsViewController:(UIViewController *)controller animated:(BOOL)animated;

@end

typedef void(^on_value_changed_t)(id originalValue, id newValue, SDFormField *field);

@interface SDFormField : NSObject

@property (nonatomic, strong) NSString *name;                   ///<Name of the field, used for identifying field

@property (nonatomic, strong) NSString *title;                  ///<Title of the field that will be displayed in cell

@property (nonatomic, strong) id value;                         ///<Value of the field

@property (nonatomic) SDFormFieldValueType valueType;           ///<Type of the value

@property (nonatomic, strong) id formattedValue;                ///<Formatted value of the field that will be displayed in cell

@property (nonatomic) BOOL hasPicker;                           ///<Indicates if the field shows picker

@property (nonatomic) BOOL enabled;                             ///<If set to YES, field will react to user interactions

@property (nonatomic, strong) NSArray *reuseIdentifiers;        ///<Reuse identifiers of cells used by field, should be set in subclasses

@property (nonatomic, strong) NSArray *cellHeights;             ///<Heights of cells displayed by field

@property (nonatomic, strong) NSIndexPath *indexPath;           //<Field's index path

@property (nonatomic) SDFormFieldPresentingMode presentingMode; ///<Tells the field how it should present its view controllers. By default it's set to SDFormFieldPresentingModePush

@property (nonatomic, strong) id relatedObject;                 ///<Object related to the field

@property (nonatomic, strong) NSString *relatedPropertyKey;     ///<Key path to property related to field

@property (nonatomic, strong) NSString *formattedValueKey;      ///<Key path to property that will be dispayed as field's formatted value

@property (nonatomic, strong) NSString *settabeFormattedValueKey;   ///<Key path to property that will be set by the field with its formattedValue property value

@property (nonatomic, strong) UIColor *backgroundColor;             ///<Background color of the field

@property (nonatomic, strong) UIColor *editedBackgroundColor;       ///<Background color of the field if it has been edited and its markWhenEdited property is set to YES

@property (nonatomic) BOOL markWhenEdited;              ///<If set to YES, the fields background color will change to editedBackgroundColor property value after the field has been edited

@property (nonatomic) BOOL isInitialValueSet;           ///<Indicates, if the field initial value of the field is set. If you set to this property to NO, the next object assigned to value property will be treaded as the field's initial value

@property (nonatomic, strong) NSString *segueIdentifier;    ///<Identifier of the segue that should be performed when the field is tapped

@property (nonatomic, strong) void (^onTapBlock)();         ///<Block executed when the field is tapped

@property (nonatomic, readonly) NSBundle *defaultBundle;    ///<Bundle containing resources associated with SDForms library

@property (nonatomic, strong) on_value_changed_t onValueChangedBlock;   ///<Block executed when value of the field has changed

@property (nonatomic) BOOL canBeDeleted;    ///<If YES, delete button will be visible on field's cells

@property (nonatomic, readonly) UIViewController *viewController;   //View controller that the form is displayed in

@property (nonatomic, weak) id<SDFormFieldDelegate> delegate;                       ///<Field's delegate

@property (nonatomic, weak) id<SDFormFieldCustomizationDelegate> formatDelegate;    ///<Field's format delegate


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
