//
//  NSMutableArray+IndexSelection.h
//  SDForms
//
//  Created by Rafal Kwiatkowski on 25.08.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (IndexSelection)

- (BOOL)isIndexSelected:(NSInteger)index;
- (void)selectIndex:(NSInteger)index;
- (void)deselectIndex:(NSInteger)index;

@end
