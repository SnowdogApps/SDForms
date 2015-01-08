//
//  NSMutableArray+IndexSelection.m
//  SDForms
//
//  Created by Rafal Kwiatkowski on 25.08.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import "NSMutableArray+IndexSelection.h"

@implementation NSMutableArray (IndexSelection)

- (BOOL)isIndexSelected:(NSInteger)index
{
    __block BOOL found = NO;
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (((NSNumber*)obj).integerValue == index) {
            found = YES;
            *stop = YES;
        }
    }];
    return found;
}

- (void)selectIndex:(NSInteger)index
{
    if (![self isIndexSelected:index]) {
        [self addObject:@(index)];
    }
}

- (void)deselectIndex:(NSInteger)index
{
    __block BOOL found = NO;
    __block NSInteger i;
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (((NSNumber*)obj).integerValue == index) {
            found = YES;
            i = idx;
            *stop = YES;
        }
    }];
    if (found) {
        [self removeObjectAtIndex:i];
    }
}

@end
