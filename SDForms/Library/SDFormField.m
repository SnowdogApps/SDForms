//
//  SDFormField.m
//  SDForms
//
//  Created by Rafal Kwiatkowski on 13.08.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import "SDFormField.h"
#import "SDFormCell.h"
#import "NSObject+Differences.h"

@interface SDFormField ()

@property (nonatomic, strong) id initialVal;

@end


@implementation SDFormField

- (id)initWithObject:(id)object relatedPropertyKey:(NSString *)key {
    self = [self init];
    if (self) {
        self.relatedObject = object;
        self.relatedPropertyKey = key;
        [self setValueBasedOnRelatedObjectProperty];
    }
    return self;
}

- (id)initWithObject:(id)object
        relatedPropertyKey:(NSString *)key
        formattedValueKey:(NSString *)formattedKey
        settableFormattedValueKey:(NSString *)settableFormattedKey {
    
    self = [self initWithObject:object relatedPropertyKey:key];
    if (self) {
        self.relatedObject = object;
        self.relatedPropertyKey = key;
        self.formattedValueKey = formattedKey;
        self.settabeFormattedValueKey = settableFormattedKey;
        [self setValueBasedOnRelatedObjectProperty];
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        self.hasPicker = NO;
        self.enabled = YES;
        self.isInitialValueSet = NO;
    }
    return self;
}

- (void)registerCellsInTableView:(UITableView *)tableView {
    for (NSString *cellId in self.reuseIdentifiers) {
        [tableView registerNib:[UINib nibWithNibName:cellId bundle:self.defaultBundle] forCellReuseIdentifier:cellId];
    }
}

- (SDFormCell *)cellForTableView:(UITableView *)tableView atIndex:(NSUInteger)index {
    if (index < self.reuseIdentifiers.count) {
        NSString *reuseIdentifier = [self.reuseIdentifiers objectAtIndex:index];
        SDFormCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.field = self;

        if (self.markWhenEdited && [self.value isDifferent:self.initialVal]) {
            cell.contentView.backgroundColor = self.editedBackgroundColor;
            cell.backgroundColor = self.editedBackgroundColor;
        } else if (self.backgroundColor) {
            cell.contentView.backgroundColor = self.backgroundColor;
            cell.backgroundColor = self.backgroundColor;
        }  else {
            cell.contentView.backgroundColor = nil;
            cell.backgroundColor = [UIColor whiteColor];
        }
        
        if (self.segueIdentifier.length > 0) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        return cell;
    }
    return nil;
}

- (void)willDisplayCell:(SDFormCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)heightForCellInTableView:(UITableView *)tableView atIndex:(NSUInteger)index {
    if (index < self.cellHeights.count) {
        NSNumber *height = [self.cellHeights objectAtIndex:index];
        return height.floatValue;
    }
    return 44.0;
}

- (void)setValue:(id)value {
    [self setValue:value withCellRefresh:YES];
}

- (void)setValue:(id)value withCellRefresh:(BOOL)refresh {
    
    if (!self.isInitialValueSet) {
        self.initialVal = value;
        self.isInitialValueSet = YES;
    }
    
    _value = value;
    
    [self setRelatedObjectProperty];
    
    if (self.onValueChangedBlock) {
        self.onValueChangedBlock(self.initialVal, value, self);
    }

    if (refresh) {
        [self refreshFieldCell];
    }
}

- (void)setRelatedObject:(id)relatedObject {
    _relatedObject = relatedObject;
    [self setValueBasedOnRelatedObjectProperty];
}

- (void) setRelatedPropertyKey:(NSString *)relatedPropertyKey {
    _relatedPropertyKey = relatedPropertyKey;
    [self setValueBasedOnRelatedObjectProperty];
}

- (void)setRelatedObjectProperty {
    if (self.relatedObject) {
        if (self.relatedPropertyKey) {
            if (![[self.relatedObject valueForKey:self.relatedPropertyKey] isEqual:self.value])
            [self.relatedObject setValue:self.value forKey:self.relatedPropertyKey];
        }
        if (self.settabeFormattedValueKey) {
            [self.relatedObject setValue:self.formattedValue forKey:self.settabeFormattedValueKey];
        }
    }
}

- (void)setValueBasedOnRelatedObjectProperty {
    if (self.relatedObject && self.relatedPropertyKey) {
        self.value = [self.relatedObject valueForKey:self.relatedPropertyKey];
    }
}

- (NSString *)formattedValue {
    if (self.formatDelegate && [self.formatDelegate respondsToSelector:@selector(formattedValueForField:)]) {
        NSString *title = [self.formatDelegate formattedValueForField:self];
        return title;
    } else if (self.relatedObject && self.formattedValueKey) {
        return [self.relatedObject valueForKeyPath:self.formattedValueKey];
    }
    
    if (self.value) {
        return [NSString stringWithFormat:@"%@", self.value];
    } else {
        return @"";
    }
}

- (void)refreshFieldCell {
    if (self.delegate && [self.delegate respondsToSelector:@selector(formFieldDidUpdateValue:)]) {
        [self.delegate formFieldDidUpdateValue:self];
    }
}

- (void)form:(SDForm *)form didSelectFieldAtIndex:(NSInteger)index {
    
}

- (void)presentViewController:(UIViewController *)controller animated:(BOOL)animated {
    if (self.delegate) {
        
        if (self.presentingMode == SDFormFieldPresentingModePush && ![controller isKindOfClass:[UINavigationController class]]) {
            
            if ([self.delegate respondsToSelector:@selector(formField:pushesViewController:animated:)]) {
                
                [self.delegate formField:self pushesViewController:controller animated:animated];
            }
        } else {
            if ([self.delegate respondsToSelector:@selector(formField:presentsViewController:animated:)]) {
                
                UIViewController *controllerToShow;
                if (![controller isKindOfClass:[UINavigationController class]]) {
                    controllerToShow = [[UINavigationController alloc] initWithRootViewController:controller];
                } else {
                    controllerToShow = controller;
                }
        
                [self.delegate formField:self presentsViewController:controllerToShow animated:YES];
            }
        }
    }
}

- (UIColor *)editedBackgroundColor {
    if (_editedBackgroundColor == nil) {
        _editedBackgroundColor = [UIColor colorWithRed:169/255.0 green:188/255.0 blue:209/255.0 alpha:1.0];
    }
    return _editedBackgroundColor;
}

- (UIViewController *)viewController {
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewControllerForField:)]) {
        return [self.delegate viewControllerForField:self];
    }
    return nil;
}

- (NSBundle *)defaultBundle {
    NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"SDFormsResources" withExtension:@"bundle"]];
    return bundle;
}

@end
