//
//  SDForm.h
//  SDForms
//
//  Created by Rafal Kwiatkowski on 13.08.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDFormSection.h"
#import "SDNavigationToolbar.h"
#import "SDFormCell.h"

@class SDForm;

@protocol SDFormDelegate <NSObject>

- (UIViewController *)viewControllerForForm:(SDForm *)form;

@optional
- (void)form:(SDForm *)form didSelectFieldAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol SDFormDataSource <NSObject>

- (NSInteger)numberOfSectionsForForm:(SDForm *)form;
- (NSInteger)form:(SDForm *)form numberOfFieldsInSection:(NSInteger)section;
- (NSString *)form:(SDForm *)form titleForHeaderInSection:(NSInteger)section;
- (NSString *)form:(SDForm *)form titleForFooterInSection:(NSInteger)section;
- (CGFloat)form:(SDForm *)form heightForHeaderInSection:(NSInteger)section;
- (CGFloat)form:(SDForm *)form heightForFooterInSection:(NSInteger)section;
- (UIView *)form:(SDForm *)form viewForHeaderInSection:(NSInteger)section;
- (UIView *)form:(SDForm *)form viewForFooterInSection:(NSInteger)section;
- (SDFormField *)form:(SDForm *)form fieldForRow:(NSInteger)row inSection:(NSInteger)section;

@end

@interface SDForm : NSObject <SDFormFieldDelegate, SDFormCellDelegate, SDNavigationToolbarDelegate, UITableViewDelegate, UITableViewDataSource>

- (id)initWithTableView:(UITableView*)tableView;
- (void)reloadData;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, weak) id<SDFormDelegate> delegate;
@property (nonatomic, weak) id<SDFormDataSource> dataSource;

@end

@interface NSIndexPath (FieldIndex)

- (NSInteger)fieldIndexWithPickerIndexPath:(NSIndexPath*)pickerIndexPath;
- (NSIndexPath *)fieldIndexPathWithPickerIndexPath:(NSIndexPath*)pickerIndexPath;

@end
