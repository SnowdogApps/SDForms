//
//  SDForm.m
//  SDForms
//
//  Created by Rafal Kwiatkowski on 13.08.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import "SDForm.h"
#import "SDFormCell.h"

// TODO: Retrieve keyboard mode in other way
#define KEYBOARD_HEIGHT 216.0   // Keyboard height in portrait mode


@interface SDForm ()

@property (strong, nonatomic) SDNavigationToolbar *toolbar;
@property (nonatomic) CGFloat prevOffset;
@property (nonatomic) CGRect prevFrame;
@property (nonatomic, strong) NSIndexPath *currentIndexPath;
@property (nonatomic, strong) NSIndexPath *pickerIndexPath;
@property (nonatomic, strong) SDFormField *fieldShowingPicker;
@property (nonatomic, strong) UIView *activeResponder;
@property (nonatomic, readonly) UIViewController *viewController;
@property (nonatomic, strong) NSMutableArray *sections;
@property (nonatomic) CGFloat keyboardHeight;

@end

@implementation SDForm

- (id)initWithTableView:(UITableView *)tableView
{
    self = [super init];
    if (self) {
        self.tableView = tableView;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"SDFormsResources" withExtension:@"bundle"]];
        self.toolbar = (SDNavigationToolbar *)[[bundle loadNibNamed:kSDNavigationToolbar owner:[[SDNavigationToolbar alloc] init] options:nil] lastObject];
        [self.toolbar setToolbarDelegate:self];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        self.keyboardHeight = KEYBOARD_HEIGHT;
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (SDFormField *)fieldForIndexPath:(NSIndexPath *)indexPath
{
    SDFormSection *formSection = [self.sections objectAtIndex:indexPath.section];
    SDFormField *formField = [formSection.fields objectAtIndex:[indexPath fieldIndexWithPickerIndexPath:self.pickerIndexPath]];
    return formField;
}

- (void)removeFieldAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)rowAnimation
{
    SDFormSection *section = [self.sections objectAtIndex:indexPath.section];
    NSMutableArray *fields = section.fields;
    SDFormField *field = [fields objectAtIndex:indexPath.row];
    
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    NSIndexPath *cellIP = [field.indexPath fieldCellIndexPathWithPickerIndexPath:self.pickerIndexPath];
    [indexPaths addObject:cellIP];
    
    NSIndexPath *probablePickerIP = [NSIndexPath indexPathForRow:cellIP.row + 1 inSection:cellIP.section];
    if ([probablePickerIP compare:self.pickerIndexPath] == NSOrderedSame) {
        [indexPaths addObject:probablePickerIP];
        self.pickerIndexPath = nil;
        self.fieldShowingPicker = nil;
    }
    
    [fields removeObject:field];
    [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:rowAnimation];
    
    [self updateFieldsIndexPaths];
}

- (void)reloadData
{
    self.sections = nil;
    BOOL foundFieldShowingPicker = NO;
    NSInteger numberOfSections = 0;
    
    if (self.dataSource) {
        if ([self.dataSource respondsToSelector:@selector(numberOfSectionsForForm:)]) {
            numberOfSections = [self.dataSource numberOfSectionsForForm:self];
        }
        
        NSMutableArray *sections = [[NSMutableArray alloc] init];
        
        for (NSInteger i = 0; i < numberOfSections; ++i) {
            SDFormSection *section = [[SDFormSection alloc] init];
            if ([self.dataSource respondsToSelector:@selector(form:titleForHeaderInSection:)]) {
                section.headerTitle = [self.dataSource form:self titleForHeaderInSection:i];
            }
            if ([self.dataSource respondsToSelector:@selector(form:titleForFooterInSection:)]) {
                section.footerTitle = [self.dataSource form:self titleForFooterInSection:i];
            }
            if ([self.dataSource respondsToSelector:@selector(form:heightForHeaderInSection:)]) {
                section.headerHeight = [self.dataSource form:self heightForHeaderInSection:i];
            }
            if ([self.dataSource respondsToSelector:@selector(form:heightForFooterInSection:)]) {
                section.footerHeight = [self.dataSource form:self heightForFooterInSection:i];
            }
            if ([self.dataSource respondsToSelector:@selector(form:viewForHeaderInSection:)]) {
                section.headerView = [self.dataSource form:self viewForHeaderInSection:i];
            }
            if ([self.dataSource respondsToSelector:@selector(form:viewForFooterInSection:)]) {
                section.footerView = [self.dataSource form:self viewForFooterInSection:i];
            }
            
            if ([self.dataSource respondsToSelector:@selector(form:numberOfFieldsInSection:)]) {
                NSInteger numberOfFields = [self.dataSource form:self numberOfFieldsInSection:i];
                
                if ([self.dataSource respondsToSelector:@selector(form:fieldForRow:inSection:)]) {
                    NSMutableArray *fields = [[NSMutableArray alloc] init];
                    
                    for (int j = 0; j < numberOfFields; ++j) {
                        SDFormField *field = [self.dataSource form:self fieldForRow:j inSection:i];
                        NSAssert(field != nil, @"SDForm dataSource must return a field from form:fieldForRow:inSection:");
                        
                        [field registerCellsInTableView:self.tableView];
                        field.delegate = self;
                        [fields addObject:field];
                        
                        if (self.fieldShowingPicker && self.fieldShowingPicker == field) {
                            foundFieldShowingPicker = YES;
                        }
                    }
                    section.fields = fields;
                }
            }
            [sections addObject:section];
        }
        
        self.sections = sections;
    }
    
    if (!foundFieldShowingPicker) {
        self.fieldShowingPicker = nil;
        self.pickerIndexPath = nil;
    }
    
    [self updateFieldsIndexPaths];
    [self.tableView reloadData];
}

- (void)updateFieldsIndexPaths
{
    for (int i = 0; i < self.sections.count; i++) {
        SDFormSection *section = [self.sections objectAtIndex:i];
        for (int j = 0; j < section.fields.count; j++) {
            SDFormField *field = [section.fields objectAtIndex:j];
            field.indexPath = [NSIndexPath indexPathForRow:j inSection:i];
        }
    }
}

#pragma mark - TableView stuff

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    SDFormSection *formSection = [self.sections objectAtIndex:section];
    if (self.pickerIndexPath && self.pickerIndexPath.section == section) {
        return formSection.fields.count + 1;
    } else {
        return formSection.fields.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SDFormSection *formSection = [self.sections objectAtIndex:indexPath.section];
    SDFormField *formField = [formSection.fields objectAtIndex:[indexPath fieldIndexWithPickerIndexPath:self.pickerIndexPath]];
    SDFormCell *cell;
    
    if ([indexPath compare:self.pickerIndexPath] != NSOrderedSame) {
        cell = [formField cellForTableView:self.tableView atIndex:0];
    } else {
        cell = [formField cellForTableView:self.tableView atIndex:1];
    }
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SDFormSection *formSection = [self.sections objectAtIndex:indexPath.section];
    SDFormField *formField = [formSection.fields objectAtIndex:[indexPath fieldIndexWithPickerIndexPath:self.pickerIndexPath]];
    CGFloat height;
    
    if ([indexPath compare:self.pickerIndexPath] != NSOrderedSame) {
        height = [formField heightForCellInTableView:self.tableView atIndex:0];
    } else {
        height = [formField heightForCellInTableView:self.tableView atIndex:1];
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    SDFormSection *formSection = [self.sections objectAtIndex:section];
    return formSection.headerHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    SDFormSection *formSection = [self.sections objectAtIndex:section];
    return formSection.footerHeight;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    SDFormSection *formSection = [self.sections objectAtIndex:section];
    return formSection.headerTitle;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    SDFormSection *formSection = [self.sections objectAtIndex:section];
    return formSection.footerTitle;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SDFormSection *formSection = [self.sections objectAtIndex:section];
    return formSection.headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    SDFormSection *formSection = [self.sections objectAtIndex:section];
    return formSection.footerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SDFormField *field = [self fieldForIndexPath:indexPath];
    
    if (field.enabled) {
        if (field.segueIdentifier.length > 0) {
            [self.viewController performSegueWithIdentifier:field.segueIdentifier sender:field];
        } else {
            if ([indexPath compare:self.pickerIndexPath] != NSOrderedSame) {
                [field form:self didSelectFieldAtIndex:0];
            }
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(form:didSelectFieldAtIndexPath:)]) {
                [self.delegate form:self didSelectFieldAtIndexPath:field.indexPath];
            }
            
            [self togglePickerForIndexPath:indexPath];
        }
    }
}

#pragma mark - Moving screen during editing stuff

- (void)animateToView:(UIView*)view up:(BOOL)up {
    UIView *responderView = nil;
    
    if ([view isKindOfClass:[UIView class]]) {
        responderView = (UIView *)view;
    }
    
    if (up) {
        self.prevOffset = self.tableView.contentOffset.y;
        self.prevFrame = self.tableView.frame;
        CGPoint point = [self.tableView convertPoint:responderView.frame.origin fromView:responderView.superview];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
        CGFloat offset = point.y;
        offset -= (self.viewController.view.frame.size.height - self.keyboardHeight) / 2;
        if (offset > 0) {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationDuration:0.3];
            CGRect frame = self.tableView.frame;
            frame.size.height = frame.size.height - self.keyboardHeight;
            self.tableView.frame = frame;
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
            [UIView commitAnimations];
            
        }
    } else {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3];
        self.tableView.frame = self.prevFrame;
        
        [UIView commitAnimations];
    }
}

#pragma mark - SDFormFieldDelegate

- (void)formFieldDidUpdateValue:(SDFormField *)field
{
    NSIndexPath *indexPath = [field.indexPath fieldCellIndexPathWithPickerIndexPath:self.pickerIndexPath];
    if (indexPath) {
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)formField:(SDFormField *)formField presentsViewController:(UIViewController *)controller animated:(BOOL)animated
{
    [self.viewController presentViewController:controller animated:animated completion:nil];
}

- (void)formField:(SDFormField *)formField pushesViewController:(UIViewController *)controller animated:(BOOL)animated
{
    [self.viewController.navigationController pushViewController:controller animated:animated];
}

#pragma mark - SDFormCellDelegate

- (void)formCell:(SDFormCell*)cell didActivateResponder:(UIView*)view
{
    [self animateToView:view up:YES];
    self.activeResponder = view;
}

- (void)formCell:(SDFormCell*)cell didDeactivateResponder:(UIView*)view
{
    [self animateToView:view up:NO];
    self.activeResponder = nil;
}

- (UIView *)inputAccessoryViewForCell:(SDFormCell *)cell
{
    return self.toolbar;
}


#pragma mark - Navigating between responders

- (void)moveToNextResponder
{
    SDFormCell *currentCell = (SDFormCell*)[self.tableView cellForRowAtIndexPath:self.currentIndexPath];
    UIView *newActiveResponder;
    
    NSInteger index = [currentCell.responders indexOfObject:self.activeResponder];
    if (index != NSNotFound && index < currentCell.responders.count - 1) {
        newActiveResponder = [currentCell.responders objectAtIndex:index + 1];
    }
    
    if(newActiveResponder) {
        self.activeResponder = newActiveResponder;
    } else {
        [self moveToAnotherCellForward:YES];
    }
}

- (void)moveToPreviousResponder
{
    SDFormCell *currentCell = (SDFormCell*)[self.tableView cellForRowAtIndexPath:self.currentIndexPath];
    UIView *newActiveResponder;
    
    NSInteger index = [currentCell.responders indexOfObject:self.activeResponder];
    if (index != NSNotFound && index > 0) {
        newActiveResponder = [currentCell.responders objectAtIndex:index - 1];
    }
    
    if(newActiveResponder) {
        self.activeResponder = newActiveResponder;
    } else {
        [self moveToAnotherCellForward:NO];
    }
}


- (NSIndexPath *) nextIndexPath:(NSIndexPath *) indexPath {
    NSInteger numOfSections = [self numberOfSectionsInTableView:self.tableView];
    NSInteger nextSection = ((indexPath.section + 1) % numOfSections);
    
    NSInteger nOfRows = [self tableView:self.tableView numberOfRowsInSection:indexPath.section];
    
    if ((indexPath.row +1) == nOfRows) {
        return [NSIndexPath indexPathForRow:0 inSection:nextSection];
    } else {
        return [NSIndexPath indexPathForRow:(indexPath.row + 1) inSection:indexPath.section];
    }
}

- (NSIndexPath *) previousIndexPath:(NSIndexPath *) indexPath {
    NSInteger numOfSections = [self numberOfSectionsInTableView:self.tableView];
    NSInteger previousSection = (indexPath.section - 1);
    if(previousSection < 0) previousSection = numOfSections - 1;
    
    NSInteger nOfRowsPrevSection = [self tableView:self.tableView numberOfRowsInSection:previousSection];
    
    if ((indexPath.row - 1) < 0) {
        return [NSIndexPath indexPathForRow:(nOfRowsPrevSection - 1) inSection:previousSection];
    } else {
        return [NSIndexPath indexPathForRow:(indexPath.row - 1) inSection:indexPath.section];
    }
}

- (void)moveToAnotherCellForward:(BOOL)forward
{
    UIView *newActiveResponder;
    NSIndexPath *nextIndexPath;
    
    if (forward) {
        nextIndexPath = [self nextIndexPath:self.currentIndexPath];
    } else {
        nextIndexPath = [self previousIndexPath:self.currentIndexPath];
    }
    
    [self.tableView scrollToRowAtIndexPath:nextIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    
    SDFormCell *nextCell = (SDFormCell*)[self.tableView cellForRowAtIndexPath:nextIndexPath];
    if (nextCell.responders.count > 0) {
        newActiveResponder = nextCell.responders.firstObject;
    } else {
        self.currentIndexPath = nextIndexPath;
    }
    
    if(newActiveResponder) {
        self.activeResponder = newActiveResponder;
    } else {
        if (forward) {
            [self moveToNextResponder];
        } else {
            [self moveToPreviousResponder];
        }
    }
}

- (UITableViewCell *)cellOfActiveResponder
{
    UIView *view = self.activeResponder;
    while (view != nil && ![view isKindOfClass:[UITableViewCell class]]) {
        view = [view superview];
    }
    UITableViewCell *currentCell = (UITableViewCell*)view;
    return currentCell;
}

#pragma mark - Pickers behavior methods

- (void)togglePickerForIndexPath:(NSIndexPath *)indexPath
{
    if(self.pickerIndexPath && [indexPath compare:self.pickerIndexPath] == NSOrderedSame)
        return;
    
    SDFormField *field = [self fieldForIndexPath:indexPath];
    NSIndexPath *origIndexPath = field.indexPath;
    NSIndexPath *probablePickerIndex = [NSIndexPath indexPathForItem:(origIndexPath.row + 1) inSection:origIndexPath.section];
    
    if(self.pickerIndexPath && [probablePickerIndex compare:self.pickerIndexPath] == NSOrderedSame) {
        
        NSIndexPath *lastPickerIndexPath = self.pickerIndexPath;
        self.pickerIndexPath = nil;
        self.fieldShowingPicker = nil;
        [self hidePickerOnIndexPath:lastPickerIndexPath];
    } else {
        
        BOOL pickerToggled = NO;
        if (field.hasPicker) {
            
            if (!self.pickerIndexPath) {
                self.pickerIndexPath = probablePickerIndex;
                self.fieldShowingPicker = field;
                [self showPickerOnIndexPath:probablePickerIndex];
                pickerToggled = YES;
            } else {
                NSIndexPath *lastPickerIndexPath = self.pickerIndexPath;
                self.pickerIndexPath = nil;
                self.fieldShowingPicker = nil;
                
                [self hidePickerOnIndexPath:lastPickerIndexPath];
                self.pickerIndexPath = probablePickerIndex;
                self.fieldShowingPicker = field;
                [self showPickerOnIndexPath:self.pickerIndexPath];
                pickerToggled = YES;
            }
        }
        
        if(!pickerToggled) {
            NSIndexPath *lastPickerIndexPath = self.pickerIndexPath;
            self.pickerIndexPath = nil;
            self.fieldShowingPicker = nil;
            NSLog(@"last_picker:%ld newPicker:%ld", (long)lastPickerIndexPath.row, (long)probablePickerIndex.row);
            [self hidePickerOnIndexPath:lastPickerIndexPath];
        }
    }
}


- (void)showPickerOnIndexPath:(NSIndexPath*)indexPath
{
    if(indexPath) {
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    }
}


- (void)hidePickerOnIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath) {
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


#pragma mark - SDNavigationToolbarDelegate

- (void)hideKeyboard
{
    self.activeResponder = nil;
}

- (void)moveToNext
{
    [self moveToNextResponder];
}

- (void)moveToPrevious
{
    [self moveToPreviousResponder];
}

#pragma mark - Notifications

- (void)keyboardWillShow:(NSNotification *)notification
{
    CGRect keyboardBeginFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect keyboardEndFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat yBegin = keyboardBeginFrame.origin.y;
    CGFloat yEnd = keyboardEndFrame.origin.y;
    self.keyboardHeight = yBegin - yEnd;
}

#pragma mark - Getters & Setters

- (UIViewController *)viewController
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewControllerForForm:)]) {
        return [self.delegate viewControllerForForm:self];
    }
    return nil;
}

- (void)setActiveResponder:(id)activeResponder
{
    if (_activeResponder != activeResponder)
    {
        [_activeResponder resignFirstResponder];
        _activeResponder = activeResponder;
        CGPoint pos = [_activeResponder convertPoint:CGPointZero toView:self.tableView];
        self.currentIndexPath = [self.tableView indexPathForRowAtPoint:pos];
        
        if(!_activeResponder.isFirstResponder)
            [_activeResponder becomeFirstResponder];
    }
}

- (void)setDelegate:(id<SDFormDelegate>)delegate
{
    _delegate = delegate;
    [self reloadData];
}

- (void)setDataSource:(id<SDFormDataSource>)dataSource
{
    _dataSource = dataSource;
    [self reloadData];
}

@end


@implementation NSIndexPath (FieldIndex)

- (NSInteger)fieldIndexWithPickerIndexPath:(NSIndexPath*)pickerIndexPath
{
    if (pickerIndexPath && self.section == pickerIndexPath.section) {
        if (self.row >= pickerIndexPath.row) {
            return self.row - 1;
        } else {
            return self.row;
        }
    }
    return self.row;
}



- (NSIndexPath *)fieldCellIndexPathWithPickerIndexPath:(NSIndexPath*)pickerIndexPath
{
    if (pickerIndexPath && self.section == pickerIndexPath.section) {
        if (self.row >= pickerIndexPath.row) {
            return [NSIndexPath indexPathForRow:self.row + 1 inSection:self.section];
        } else {
            return self;
        }
    }
    return self;
}

@end