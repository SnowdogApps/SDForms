//
//  SDTextFormField.h
//  SDForms
//
//  Created by Rafal Kwiatkowski on 13.08.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDFormField.h"

typedef enum {SDTextFormFieldCellTypeTextOnly, SDTextFormFieldCellTypeTextAndLabel} SDTextFormFieldCellType;

@interface SDTextFormField : SDFormField

@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic) UITextAutocapitalizationType autocapitalizationType;
@property (nonatomic) UITextAutocorrectionType autocorrectionType;
@property (nonatomic) BOOL secure;
@property (nonatomic) SDTextFormFieldCellType cellType;

@end
