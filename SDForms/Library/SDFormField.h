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

@interface SDFormField : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) id value;
@property (nonatomic) SDFormFieldValueType valueType;
@property (nonatomic, strong) NSString *formattedValue;
@property (nonatomic) BOOL hasPicker;
@property (nonatomic, strong) NSArray *reuseIdentifiers;
@property (nonatomic, strong) NSArray *cellHeights;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic) SDFormFieldPresentingMode presentingMode; ///<Tells the field how it should present its view controllers. By default it's set to SDFormFieldPresentingModePush
@property (nonatomic, strong) id relatedObject;
@property (nonatomic, strong) NSString *relatedPropertyKey;
@property (nonatomic, readonly) NSBundle *defaultBundle;

@property (nonatomic, weak) id<SDFormFieldDelegate> delegate;
@property (nonatomic, weak) id<SDFormFieldCustomizationDelegate> formatDelegate;

- (id)initWithObject:(id)object relatedPropertyKey:(NSString *)key;
- (void)registerCellsInTableView:(UITableView*)tableView;
- (SDFormCell *)cellForTableView:(UITableView*)tableView atIndex:(NSUInteger)index;
- (CGFloat)heightForCellInTableView:(UITableView *)tableView atIndex:(NSUInteger)index;
- (void)setValue:(id)value withCellRefresh:(BOOL)refresh;
- (void)refreshFieldCell;
- (void)form:(SDForm *)form didSelectFieldAtIndex:(NSInteger)index;
- (void)presentViewController:(UIViewController *)controller animated:(BOOL)animated;

@end
