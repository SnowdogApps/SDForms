//
//  SDItemsPickerViewController.h
//  SDForms
//
//  Created by Rafal Kwiatkowski on 22.01.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SDFormItemsPickerViewController;


@protocol  SDItemsPickerViewControllerDelegate <NSObject>
@optional
- (void)itemsPickerViewController:(SDFormItemsPickerViewController*)controller didSelectElementAtIndex:(NSInteger)index;
- (void)itemsPickerViewController:(SDFormItemsPickerViewController*)controller didDeselectElementAtIndex:(NSInteger)index;

@end

/**
 @description Picker of items. By default it treats items as NSString objects. To use different class of objects, subclass this class and override method tableView:cellForRowAtIndexPath:
 */
@interface SDFormItemsPickerViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) BOOL multiChoice;
@property (nonatomic) NSInteger tag;
@property (strong, nonatomic) NSArray *items;
@property (strong, nonatomic) NSMutableArray *selectedIndexes;
@property (weak, nonatomic) id<SDItemsPickerViewControllerDelegate> delegate;

@end
