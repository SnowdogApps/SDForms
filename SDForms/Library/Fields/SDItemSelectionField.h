//
//  SDItemSelectionFormField.h
//  SDForms
//
//  Created by Rafal Kwiatkowski on 25.08.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import "SDFormField.h"

@interface SDItemSelectionField : SDFormField

@property (nonatomic, strong) NSArray *items;   ///< Array of items. Items should be of (NSString *) type
@property (strong, nonatomic) NSMutableArray *selectedIndexes;
@property (nonatomic) BOOL multiChoice;

@end
