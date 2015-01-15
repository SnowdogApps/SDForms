//
//  SDForm.h
//  SDForms
//
//  Created by Rafal Kwiatkowski on 13.08.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDFormSection.h"
#import "SDFormKeyboardToolbar.h"
#import "SDFormCell.h"

@class SDForm;

@protocol SDFormDelegate <NSObject>

- (UIViewController *)viewControllerForForm:(SDForm *)form;

@optional
- (void)form:(SDForm *)form didSelectFieldAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)form:(SDForm *)form canEditFieldAtIndexPath:(NSIndexPath *)indexPath;
- (void)form:(SDForm *)form commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forFieldAtIndexPath:(NSIndexPath *)indexPath;

- (BOOL)form:(SDForm *)form canEditRowAtIndexPath:(NSIndexPath *)indexPath __deprecated;
- (void)form:(SDForm *)form commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath __deprecated;

@end

@protocol SDFormDataSource <NSObject>

- (NSInteger)numberOfSectionsForForm:(SDForm *)form;
- (NSInteger)form:(SDForm *)form numberOfFieldsInSection:(NSInteger)section;
- (SDFormField *)form:(SDForm *)form fieldForRow:(NSInteger)row inSection:(NSInteger)section;

@optional
- (NSString *)form:(SDForm *)form titleForHeaderInSection:(NSInteger)section;
- (NSString *)form:(SDForm *)form titleForFooterInSection:(NSInteger)section;
- (CGFloat)form:(SDForm *)form heightForHeaderInSection:(NSInteger)section;
- (CGFloat)form:(SDForm *)form heightForFooterInSection:(NSInteger)section;
- (UIView *)form:(SDForm *)form viewForHeaderInSection:(NSInteger)section;
- (UIView *)form:(SDForm *)form viewForFooterInSection:(NSInteger)section;


@end

@interface SDForm : NSObject <SDFormFieldDelegate, SDFormCellDelegate, SDFormKeyboardToolbarDelegate, UITableViewDelegate, UITableViewDataSource>

- (id)initWithTableView:(UITableView*)tableView;
- (SDFormField *)fieldForIndexPath:(NSIndexPath *)indexPath;

- (void)addField:(SDFormField *)field atIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)rowAnimation;
- (void)addSectionAtIndex:(NSInteger)index withRowAnimation:(UITableViewRowAnimation)rowAnimation;
- (void)removeFieldAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)rowAnimation;
- (void)removeSectionAtIndex:(NSInteger)index withRowAnimation:(UITableViewRowAnimation)rowAnimation;
- (void)scrollToIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated;

- (void)reloadData;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, weak) id<SDFormDelegate> delegate;
@property (nonatomic, weak) id<SDFormDataSource> dataSource;

@end

@interface NSIndexPath (FieldIndex)

- (NSInteger)fieldIndexWithPickerIndexPath:(NSIndexPath*)pickerIndexPath;
- (NSIndexPath *)fieldCellIndexPathWithPickerIndexPath:(NSIndexPath*)pickerIndexPath;

@end
