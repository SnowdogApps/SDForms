//
//  SDItemsPickerViewController.m
//  SDForms
//
//  Created by Rafal Kwiatkowski on 22.01.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import "SDItemsPickerViewController.h"
#import "NSMutableArray+IndexSelection.h"

static NSString *kStandardCell = @"StandardCell";

@interface SDItemsPickerViewController ()

@end

@implementation SDItemsPickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.multiChoice = NO;
    }
    return self;
}

- (id) init
{
    NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"SDFormsResources" withExtension:@"bundle"]];
    self = [self initWithNibName:@"SDItemsPickerViewController" bundle:bundle];
    if(self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self isModal]) {
        [self setupDoneButton];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupDoneButton
{
    UIBarButtonItem *customItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(doneButtonTapped:)];
    self.navigationItem.rightBarButtonItem = customItem;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kStandardCell];
    
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kStandardCell];
    }
    NSString *item = [self.items objectAtIndex:indexPath.row];
    [cell.textLabel setText:item];
    [cell.textLabel setFont:[UIFont fontWithName:@"Helvetice-Neue-Thin" size:17.0]];
    
    if([self.selectedIndexes isIndexSelected:indexPath.row]) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(self.multiChoice)  {
        if([self.selectedIndexes isIndexSelected:indexPath.row]) {
            [self.selectedIndexes deselectIndex:indexPath.row];
            if(self.delegate && [self.delegate respondsToSelector:@selector(itemsPickerViewController:didDeselectElementAtIndex:)]) {
                [self.delegate itemsPickerViewController:self didDeselectElementAtIndex:indexPath.row];
            }
        }
        else {
            [self.selectedIndexes selectIndex:indexPath.row];
            if(self.delegate && [self.delegate respondsToSelector:@selector(itemsPickerViewController:didSelectElementAtIndex:)]) {
                [self.delegate itemsPickerViewController:self didSelectElementAtIndex:indexPath.row];
            }
        }
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    } else {
        NSIndexPath *previousIndexPath;
        
        if(![self.selectedIndexes isIndexSelected:indexPath.row]) {
            if (self.selectedIndexes.count > 0) {
                NSNumber *previousIndex = self.selectedIndexes.lastObject;
                previousIndexPath = [NSIndexPath indexPathForRow:previousIndex.integerValue inSection:indexPath.section];
            }
            [self.selectedIndexes removeAllObjects];
            [self.selectedIndexes addObject:@(indexPath.row)];
            
            if(self.delegate) {
                if(previousIndexPath && [self.delegate respondsToSelector:@selector(itemsPickerViewController:didDeselectElementAtIndex:)])
                    [self.delegate itemsPickerViewController:self didDeselectElementAtIndex:previousIndexPath.row];
                if([self.delegate respondsToSelector:@selector(itemsPickerViewController:didSelectElementAtIndex:)])
                    [self.delegate itemsPickerViewController:self didSelectElementAtIndex:indexPath.row];
            }
            
            NSArray *indexPathsToReload = previousIndexPath ? @[indexPath, previousIndexPath] : @[indexPath];
            [tableView reloadRowsAtIndexPaths:indexPathsToReload withRowAnimation:UITableViewRowAnimationNone];
        }
        
        [self dismissSelf];
    }
}

#pragma mark - UIActions

- (void) doneButtonTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Setters

- (void) setItems:(NSMutableArray *)items
{
    _items = [items copy];
}

- (void)setSelectedIndexes:(NSMutableArray *)selectedIndexes
{
    for (NSNumber *index in selectedIndexes) {
        NSAssert(self.items.count > 0 && (index.integerValue >= 0 && index.integerValue < self.items.count), @"Selected index %@ beyond bounds of items array (%ld)", index, self.items.count);
    }
    
    _selectedIndexes = selectedIndexes;
    [self.tableView reloadData];
}

- (NSMutableArray *)selectedIndexes
{
    if (!_selectedIndexes) {
        _selectedIndexes = [[NSMutableArray alloc] init];
    }
    return _selectedIndexes;
}

- (BOOL)isModal {
    return self.presentingViewController.presentedViewController == self
    || (self.navigationController.presentingViewController.presentedViewController == self.navigationController &&
        [self.navigationController.viewControllers indexOfObject:self] == 0)
    || [self.tabBarController.presentingViewController isKindOfClass:[UITabBarController class]];
}

- (void)dismissSelf
{
    if ([self isModal]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@synthesize selectedIndexes = _selectedIndexes;

@end
